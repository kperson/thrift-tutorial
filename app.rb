require 'thrift'
$:.push('gen-rb')

require_relative 'dao/user_dao'
require_relative 'dao/message_dao'
require_relative 'create_server'
require_relative 'gen-rb/chat_a_p_i'

class ChatHandler

  def addNewUser(username)
    if !UserDAO.instance.find_user_by_username(username)
      user = UserDAO.instance.add_new_user(username)
      return user[:token]
    else
      raise UserAlreadyRegisteredException.new(username + " already exists")
    end
  end

  def sendMessage(chat_message, recipient, token)
  	msg_key = MessageDAO.instance.add_new_message(chat_message.message, chat_message.image, recipient)
    MessageDAO.instance.send_push_notification(msg_key, recipient, token)
  end

end


CreateServer.create_server(ChatHandler.new())