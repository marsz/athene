Airbrake.configure do |config|
  if ["development", "production"].include?(Rails.env)
    config.api_key = YAML.load_file(File.open("config/airbrake.yml"))[Rails.env][:api_key]
  end
  # config.development_environments = ["test"]
end