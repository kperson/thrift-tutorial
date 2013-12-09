require 'singleton'
require_relative '../lib/file_helper'

class UserDAO

  include Singleton

  def find_user_by_username(username)
    list = user_list
    if list.include?(username)
      return username
    else
      return nil
    end
  end

  #If user exists, methods returns null, otherwise it returns a token
  def add_new_user(username)
    token =  (0...50).map { (65 + rand(26)).chr }.join
    user = { :username => username, :token => token }
  end 

  def user_list()
    FileHelper.instance.file_at('storage/user.json')
  end

end