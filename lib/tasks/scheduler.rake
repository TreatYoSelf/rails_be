desc "This task is called by the Heroku scheduler add-on"
task :send_treats => :environment do
  user = User.all
  user.each do
    SchedulerService.new(current_user).schedule_suggestions 
  end
end