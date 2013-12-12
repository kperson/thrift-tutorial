#!/usr/bin/env ruby1.9

require 'thrift'
$:.push('gen-rb')

require_relative 'gen-rb/chat_a_p_i'

transport = Thrift::BufferedTransport.new(Thrift::HTTPClientTransport.new("http://127.0.0.1:8080"))
#transport = Thrift::BufferedTransport.new(Thrift::HTTPClientTransport.new("http://server-env-kyr2mdefeg.elasticbeanstalk.com"))
protocol = Thrift::BinaryProtocol.new(transport)
client = ChatAPI::Client.new(protocol)

brian = "Brian"
kelton = "Kelton"

brian_token = client.addNewUser(brian)
kelton_token = client.addNewUser(kelton)

message = "hey kelton. im using the ruvby!"
client.sendMessage(message, kelton, brian_token)

#client.sendMessage(message, brian, kelton_token)