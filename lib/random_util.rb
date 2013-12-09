module RandomUtil

  def RandomUtil.random_string(len)
    return (0...len).map { (65 + rand(26)).chr }.join
  end

end