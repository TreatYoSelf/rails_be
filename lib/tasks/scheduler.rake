desc "This task is called by the Heroku scheduler add-on"
task :send_treats => :environment do
  user = User.all
  user.each do
    SchedulerService.new(current_user).schedule_suggestions 
  end
end

task :send_reminders => :environment do
  User.send_reminders
end