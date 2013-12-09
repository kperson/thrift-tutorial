#!/usr/bin/env ruby1.9

require 'thrift'
$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('127.0.0.1', 8080))
protocol = Thrift::BinaryProtocol.new(transport)
client = ChatAPI::Client.new(protocol)
transport.open()
username = "Susie"
username1 = "Samwise"
begin 
  puts username + " added with token " + client.addNewUser(username)
rescue UserAlreadyRegisteredException => e 
  puts username + " already exists"
end
begin 
  puts username1 + " added with token " + client.addNewUser(username1)
rescue UserAlreadyRegisteredException => e 
  puts username1 + " already exists"
end

message = "Hey Silly Susie"
chatMessage = ChatMessage.new()
chatMessage.message = message
chatMessage.image = []
puts username + " @ " + username1 + " >> " + message
client.sendMessage(chatMessage,username1,"token")