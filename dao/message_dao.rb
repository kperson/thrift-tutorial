require 'singleton'
require "json"
require_relative '../lib/file_helper'

class MessageDAO

  include Singleton

  def add_new_message(message,recipient)
  	my_messages = messages
  	randomKey = (0...50).map { (65 + rand(26)).chr }.join
  	msg = { :recipient => recipient, :message => message }
  	my_messages[randomKey] = msg
  	FileHelper.instance.write_file_at('storage/messages.json', JSON.generate(my_messages))
  	randomKey
  end

  def messages()
  	file = 'storage/messages.json'
  	if File.exist?(file)
  		JSON.parse(FileHelper.instance.local_file_at(file))
  	else
  		{}
  	end
  end

end