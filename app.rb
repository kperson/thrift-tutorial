require 'thrift'

$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

# provide an implementation of ChatAPI
class ChatHandler

  def addNewUser(username)
  end

  def sendMessage(message, username, token)
  end

end

# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - Web-service will run as a single thread, on port 9090

handler = ChatHandler.new()
processor = ChatAPI::Processor.new(handler)
transport = Thrift::ServerSocket.new(9090)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)
puts "Starting the Chat server..."
server.serve()
puts "done"