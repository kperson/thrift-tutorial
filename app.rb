require 'thrift'
$:.push('gen-rb')

require_relative 'dao/user_dao'
require_relative 'dao/message_dao'
require_relative 'create_server'
require_relative 'gen-rb/chat_a_p_i'

class ChatHandler

  def addNewUser(username)
    user = UserDAO.instance.find_user_by_username(username)
    if !user
      return UserDAO.instance.add_new_user(username)['token']
    else
      return user['token']
    end
  end

  def sendMessage(message, recipient, token)
  	return MessageDAO.instance.add_new_message(message, recipient, token)
  end

  def getConversation(friend_username, token)
    return MessageDAO.instance.find_chat_messages_by_token(friend_username, token)
  end

  def registerAndroidToken(push_token, token)
    UserDAO.instance.add_android_token(push_token, token)
  end

  def registeriOSToken(push_token, token)
    UserDAO.instance.add_ios_token(push_token, token)
  end

end

if __FILE__ == $0
  CreateServer.create_server(ChatHandler.new(), 8080)
end