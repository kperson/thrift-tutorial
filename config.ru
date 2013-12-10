require 'rubygems'
require 'bundler'
Bundler.require

require './app.rb'

run CreateServer.create_production_server(ChatHandler.new())