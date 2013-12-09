#!/usr/bin/env ruby1.9

require 'thrift'
$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('127.0.0.1', 8080))
protocol = Thrift::BinaryProtocol.new(transport)
client = ChatAPI::Client.new(protocol)
transport.open()
username = "Susie"
begin 
  puts username + " added with token " + client.addNewUser(username)
rescue UserAlreadyRegisteredException => e 
  puts username + " already exists"
end