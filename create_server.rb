# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - Web-service will run as a single thread, on port 8080
module CreateServer
  def CreateServer.create_server(handler)
    processor = ChatAPI::Processor.new(handler)
    transport = Thrift::ServerSocket.new(8080)
    transportFactory = Thrift::BufferedTransportFactory.new()
    server = Thrift::SimpleServer.new(processor, transport, transportFactory)
    puts "Chat Server Started..."
    server.serve()
  end
end