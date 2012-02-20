begin
  fog_config = ActiveSupport::HashWithIndifferentAccess.new YAML.load_file("#{Rails.root}/config/fog.yml")[Rails.env]
rescue
  p "fog config initial error"
end

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => fog_config[:aws][:access_key_id],       # your aws access key id
    :aws_secret_access_key  => fog_config[:aws][:secret_access_key]       # your aws secret access key
    # :region                 => 'ap-southeast-1'  # your bucket's region in S3, defaults to 'us-east-1'
  }
  # your S3 bucket name
  config.fog_directory  = fog_config[:aws][:bucket]
  # custome your domain on aws S3, defaults to nil
  config.fog_host       = fog_config[:aws][:host]
  config.fog_public     = true                                   # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end