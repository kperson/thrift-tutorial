require 'singleton'
require "json"
require_relative '../lib/file_helper'
require_relative '../lib/random_util'

class UserDAO

  @@storage_file = 'storage/user.json'

  include Singleton

  def find_user_by_username(username)
    return user_list().select{ |u| u['username'] == username }.first
  end

  def find_user_by_token(token)
    return user_list().select{ |u| u['token'] == token }.first
  end  

  def add_new_user(username)
    token =  RandomUtil.random_string(50)
    user = { 'username' => username, 'token' => token }
    users = user_list
    users << user
    FileHelper.instance.write_file_at(@@storage_file, JSON.generate(users))
    return user
  end 

  def user_list()
    return File.exist?(@@storage_file) ? JSON.parse(FileHelper.instance.local_file_at(@@storage_file)) : []
  end

end