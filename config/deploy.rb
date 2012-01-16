$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"

require 'capistrano/ext/multistage'
require "whenever/capistrano"
require 'bundler/capistrano'

# require './config/boot'
# require 'airbrake/capistrano'

begin
  require 'capistrano_colors'
rescue LoadError
  puts "`gem install capistrano_colors` to get output more userfriendly."
end


set :application, "athene"
set :repository,  "git@github.com:marsz/athene.git"

set :scm, :git

set :stages,        %w(staging production)
set :default_stage, "staging"

set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :symlink_shared, :roles => [:app] do
    config_files = [:database,:medusa,:builder,:email,:airbrake,:resque]
    symlink_hash = {}
    config_files.each do |fname|
      symlink_hash["#{shared_path}/config/#{fname}.yml"] = "#{release_path}/config/#{fname}.yml"
    end
    symlink_hash.each do |source, target|
      run "ln -s #{source} #{target}"
    end
  end
end

task :seed_data, :roles => :app do
  run "cd #{current_path};bundle exec rake db:seed RAILS_ENV=#{rails_env}"
end

task :tail_log, :roles => :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log"
end

before "deploy:assets:symlink", "deploy:symlink_shared"
after "deploy", "deploy:cleanup"
