module CreateServer
  def CreateServer.create_server(handler, port)
    processor = ChatAPI::Processor.new(handler)
    transport_factory = Thrift::BufferedTransportFactory.new()
    server = Thrift::ThinHTTPServer.new(processor, { :port => port })
    server.serve()
    puts "Chat Server Started..."
  end

  def CreateServer.create_production_server(handler)
    processor = ChatAPI::Processor.new(handler)
    protocol = Thrift::BinaryProtocolFactory.new
    Thrift::ThinHTTPServer::RackApplication.for("/", processor, protocol)
  end  
end