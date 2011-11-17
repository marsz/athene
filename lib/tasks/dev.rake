namespace :dev do 
  task :rebuild => ["db:drop","db:create","db:migrate","db:seed"]
  task :fake  => :environment do
  end
end