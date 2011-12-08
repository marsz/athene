set :rails_env, "production"
set :user, 'marsz'
set :domain, 'athene.marsz.tw'
set :branch, 'master'

server "#{domain}", :web, :app, :db, :primary => true
set :deploy_to, "/home/#{user}/#{domain}"
