namespace :seed do
  task :wretch do
    Crawlers::Wretch.new.seed
  end
end