if ["production","development"].include?(Rails.env)
  config = YAML.load_file("#{Rails.root}/config/resque.yml")[Rails.env]
  Resque.redis = config[:redis]
  begin
    Resque.info
  rescue Errno::ECONNREFUSED
    puts "cant connect to redis server"
  end
  
end