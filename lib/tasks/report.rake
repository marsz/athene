namespace :report do
  task :daily => :environment do
    ReportMailer.daily.deliver
  end
end
