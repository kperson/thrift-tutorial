require 'singleton'
require "json"
require "apns"
require "gcm"
require_relative '../lib/file_helper'
require_relative 'user_dao'
require_relative '../gen-rb/chat_a_p_i'

class MessageDAO

  include Singleton

  @@message_file = 'storage/messages.json'

  def add_new_message(message, recipient, sender_token)
    recipient_user = UserDAO.instance.find_user_by_username(recipient)
    sending_user = UserDAO.instance.find_user_by_token(sender_token)
  	my_messages = messages()
  	id = RandomUtil.random_string(50)
  	msg = { 'id' => id, 'recipient' => recipient_user['username'], 'sender' => sending_user['username'], 'message' => message }
  	my_messages << msg
  	FileHelper.instance.write_file_at(@@message_file, JSON.generate(my_messages))
    send_push_notification(id, recipient)
    return id
  end

  def find_message(message_id, token)
    recipient_user = UserDAO.instance.find_user_by_token(token)
    return messages().select{ |x| x['id'] == message_id && x['recipient'] == recipient_user['username'] }.first
  end

  def find_message_by_message_id(message_id)
    return messages().select{ |x| x['id'] == message_id }.first
  end

  def find_messages_by_token(friend_user_name, token)
    me = UserDAO.instance.find_user_by_token(token)
    my_messages = messages()
    return my_messages.select do |x| 
      (x['recipient'] == friend_user_name && x['sender'] == me['username']) || 
      (x['sender'] == friend_user_name && x['recipient'] == me['username']) 
    end
  end

  def find_chat_messages_by_token(friend_user_name, token)
    list = find_messages_by_token(friend_user_name, token)
    new_list = list.collect do |x|
      chat_message = ChatMessage.new()
      chat_message.content = x['message']
      chat_message.recipient = x['recipient']
      chat_message.sender = x['sender']
      chat_message
    end
    return new_list
  end

  def messages()
    return File.exist?(@@message_file) ? JSON.parse(FileHelper.instance.local_file_at(@@message_file)) : [ ]
  end

  def send_push_notification(msg_key, recipient)    
    configure_push()
    rec = UserDAO.instance.find_user_by_username(recipient)
    message = MessageDAO.instance.find_message_by_message_id(msg_key)
    payload = {:message => message['message'], :id => msg_key, :sender => message['sender'] }
    if rec['android_push_token']
      puts "PUSHING: " + rec['android_push_token']
      gcm = GCM.new("AIzaSyC2PvKKhv1pzpH02Zt3liit4ZyjK2jWFao")
      puts gcm.send_notification([rec['android_push_token']], { data: payload, collapse_key: msg_key })
    end
    if rec['ios_push_token']
      APNS.send_notification(rec['ios_push_token'], :alert => message['message'], :badge => 0, :other => payload)
    end
  end


  def configure_push()
    
    #APNS.host = 'gateway.sandbox.push.apple.com' 
    # gateway.push.apple.com is for production
    APNS.pem  = FileHelper.instance.local_file_path('static/cert.pem')    
    #APNS.port = 2195 
  end

end