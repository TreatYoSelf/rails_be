desc "This task is called by the Heroku scheduler add-on"
task :send_treats => :environment do
  user = User.all
  user.foreach do
    
    # instanciate service class with user google token .schedule suggestions
    # calling on the methods in the service to get the open slots

    # step 2: add to user data base add refresh token
    # add in refresh token logic
    # show up in calendar
    # can figure out how to send info back to joel
  end
end

task :send_reminders => :environment do
  User.send_reminders
end

# proof of concept