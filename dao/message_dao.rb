require 'singleton'
require "json"
require "pushmeup"
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
    puts message
    puts recipient
    puts sender_token
    puts my_messages
  	id = RandomUtil.random_string(50)
  	msg = { 'id' => id, 'recipient' => recipient_user['username'], 'sender' => sending_user['username'], 'message' => message }
  	my_messages << msg
  	FileHelper.instance.write_file_at(@@message_file, JSON.generate(my_messages))
    return id
  end

  def find_message(message_id, token)
    recipient_user = UserDAO.instance.find_user_by_token(token)
    return messages().select{ |x| x['id'] == message_id && x['recipient'] == recipient_user['username'] }.first
  end

  def find_message_by_message_id(message_id)
    recipient_user = UserDAO.instance.find_user_by_token(token)
    return messages().select{ |x| x['id'] == message_id }.first
  end

  def find_messages_by_token(friend_user_name, token)
    me = UserDAO.instance.find_user_by_token(token)
    return messages().select do |x| 
      (x['recipient'] == friend_user_name && x['sender'] == me['username']) || 
      (x['sender'] == friend_user_name && x['recipient'] == me['username']) 
    end
  end

  def find_chat_messages_by_token(friend_user_name, token)
    list = find_messages_by_token(friend_user_name, token)
    return list.collect do |x|
      chat_message = ChatMessage.new()
      chat_message.content = x['message']
      chat_message.recipient = x['recipient']
      chat_message.sender = x['sender']
      chat_message
    end
  end

  def messages()
    return File.exist?(@@message_file) ? JSON.parse(FileHelper.instance.local_file_at(@@message_file)) : [ ]
  end

  def send_push_notification(msg_key, recipient, token)    
    configure_push()
    rec = UserDAO.instance.find_user_by_username(recipient)
    
    if rec['android_push_notification']
      message = find_message_by_message_id(msg_key)
      payload = {:message => message['message'], :id => msg_key }
      note = GCM::Notification.new(rec['android_push_notification'], data)
      GCM.send_notifications([note])
    end
  end

  def configure_push()
    GCM.host = 'https://android.googleapis.com/gcm/send'
    GCM.format = :json
    GCM.key = "954579491697"
  end

end