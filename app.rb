require 'thrift'
require_relative 'dao/user_dao'

$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

# provide an implementation of ChatAPI
class ChatHandler

  def addNewUser(username)
    if !UserDAO.instance.find_user_by_username(username)
      user = UserDAO.instance.add_new_user(username)
      return user[:token]
    else
      raise UserAlreadyRegisteredException.new(username + " already exists")
    end
  end

  def sendMessage(message, username, token)
  end

end

# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - Web-service will run as a single thread, on port 8080

handler = ChatHandler.new()
processor = ChatAPI::Processor.new(handler)
transport = Thrift::ServerSocket.new(8080)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::ThreadedServer.new(processor, transport, transportFactory)
puts "Starting the Chat server..."
server.serve()
puts "done"