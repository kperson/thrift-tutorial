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

  def add_android_token(android_push_token, token)
    puts "SAMPLE PUSH: " + android_push_token
    MessageDAO.instance.sample_push(android_push_token)
    user = find_user_by_token(token)
    my_users = user_list()
    index = my_users.index(user)
    my_users[index]['android_push_token'] = android_push_token
    puts index
    puts user
    puts android_push_token
    FileHelper.instance.write_file_at(@@storage_file, JSON.generate(my_users))
  end

  def add_ios_token(ios_push_token, token)
    user = find_user_by_token(token)
    my_users = user_list()
    index = my_users.index(user)
    my_users[index]['ios_push_token'] = ios_push_token
    FileHelper.instance.write_file_at(@@storage_file, JSON.generate(my_users))
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