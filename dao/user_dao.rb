require 'singleton'
require "json"
require_relative '../lib/file_helper'

class UserDAO

  include Singleton

  def find_user_by_username(username)
    user_list.select{ |u| u['username'] == username }.first
  end

  #If user exists, methods returns null, otherwise it returns a token
  def add_new_user(username)
    token =  (0...50).map { (65 + rand(26)).chr }.join
    user = { :username => username, :token => token }
    users = user_list
    users << user
    FileHelper.instance.write_file_at('storage/user.json', JSON.generate(users))
    return user
  end 

  def save_users(users)
  end

  def user_list()
    file = 'storage/user.json'
    if File.exist?(file)
      JSON.parse(FileHelper.instance.local_file_at(file))
    else
      []
    end
  end

end