require 'singleton'
require "json"
require_relative '../lib/file_helper'
require_relative 'user_dao'
require_relative '../gen-rb/chat_a_p_i'

class MessageDAO

  include Singleton

  @@message_file = 'storage/messages.json'

  def add_new_message(message, image_array, recipient)
    user = UserDAO.instance.find_user_by_username(recipient)
  	my_messages = messages
  	message_key = RandomUtil.random_string(50)
  	msg = { 'recipient' => recipient, 'message' => message }
    if !image_array.empty?
      msg['image'] = save_image(image_array)
    end
  	my_messages[message_key] = msg
  	FileHelper.instance.write_file_at(@@message_file, JSON.generate(my_messages))
    return message_key
  end

  def fetch_image(message_key)
    msg = messages()[message_key]
    chat_message = ChatMessage.new()
    chat_message.message = msg['message']
    chat_message.image = msg['image'] ? FileHelper.instance.local_file_at(msg['image']) : []
    return chat_message
  end

  def save_image(image_array)
    local_path = "storage/images/" + RandomUtil.random_string(50) + ".jpg"
    abs_path = FileHelper.instance.local_file_path(local_path)
    FileHelper.instance.write_file_at(abs_path, image_array)
    local_path
  end

  def delete_message(message_key)
    my_messages = messages()
    msg = my_messages[message_key]
    my_messages.delete(message_key)
    if msg['image']
      FileHelper.instance.delete_local_file_at(msg['image'])
    end
  end

  def messages()
    File.exist?(@@message_file) ? JSON.parse(FileHelper.instance.local_file_at(@@message_file)) : { }
  end

  def send_push_notification(msg_key, recipient, token)
  end

end