#!/usr/bin/env ruby1.9

require 'thrift'
$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('http://205.178.38.137', 9090))
protocol = Thrift::BinaryProtocol.new(transport)
client = ChatAPI::Client.new(protocol)
transport.open()

puts client.addNewUser("Brian")

