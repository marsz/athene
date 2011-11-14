namespace :dev do 
  task :rebuild => ["db:drop","db:create","db:migrate","dev:init"]
  task :fake  => :environment do
  end
end