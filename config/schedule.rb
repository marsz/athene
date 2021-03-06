# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every 2.hours do
#   rake "cron:monitor_users:wretch"
#   rake "cron:monitor_users:pixnet"
# end

every 12.hours do
  rake "cron:monitor_posts:wretch"
  rake "cron:monitor_posts:pixnet"
end

every 8.hours do
  rake "cron:builder:trigger"
end

every 1.day, :at => "am 07:00" do
  rake "report:daily"
end

every 3.days do
  rake "cron:check_users_enabled"
end

every 1.hour do
  rake "cron:download_users_avatar"
  rake "cron:check_users_enabled_by_avatar"
end