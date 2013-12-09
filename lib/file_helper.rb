require 'singleton'
require 'fileutils'

class FileHelper

  include Singleton

  def local_file_at(file)
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/" + file
    file = File.open(path, "rb")
    contents = file.read
    file.close
    contents
  end

  def write_file_at(file, content)
    FileUtils.mkdir_p(File.dirname(file))
    File.open(file, 'w') do |file|
      file.write(content)
    end
  end

  def delete_local_file_at(file)
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/" + file
    if File.exist?(path)
      File.delete(path)
    end
  end

end