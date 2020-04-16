class SchedulerService
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "date"
  require "fileutils"

  attr_reader :current_user, :weekdays, :hour_scheduled_times

  def initialize(current_user)
    @current_user = current_user
    @weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @hour_scheduled_times = [("08:01".."08:59"), ("09:01".."09:59"),("10:01".."10:59"),("11:01".."11:59"),("12:01".."12:59"),( "13:01".."13:59"),( "14:01".."14:59"), ("15:01".."15:59"), ("16:01".."16:59"), ("17:01".."17.59"), ("18:01".."18:59"),( "19:01".."19:59"), ("20:01".."20:59")]
  end

  # sets up initial Google Calendar Service with current user's google token
  def get_calendar_service
    service ||= Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Treat Yo Self"
    service.authorization = @current_user.google_token
    print "First Name: #{@current_user.first_name }"
    print "Google Token: #{@current_user.google_token}"
    print "Service: #{service}"
    service
  end

  # Uses Google Service to find a list of user events within current week time period
  def find_user_events
    calendar_id = "primary"
    response = get_calendar_service.list_events( calendar_id,
                                   time_min: DateTime.now.rfc3339,
                                   time_max: (DateTime.now + 1.week).rfc3339,
                                   single_events: true,
                                   order_by: "startTime" )
  end

  # Sets available times from 8 a.m. - 8 p.m. as a string and puts that
  # in an array by the minute i.e. ["08:00", "08:01", "08:02"]
  def available_time
    available_times = ("08:00".."20:00").to_a
    available_times.delete_if do |time|
    # since this is a string this deletes any minute over 00:59 ex. (09:60 would be deleted)
    # this returns an array with more realistic time frames
     time.split("")[3].to_i > 5
    end
  end

  # Uses the array of events to subract event time frames from a user's availability.
  def availability
    find_user_events.items.reduce({}) do |acc, event|
      # Sets start and end time frames from a single event
      start_time = event.original_start_time
      start_time = event.start if event.original_start_time.nil?
      end_time = event.end.date_time if event.end.date.nil?
      end_time = event.end.date if event.end.date_time.nil?
      weekday = start_time.date.strftime("%A") if start_time.date_time.nil?
      weekday = start_time.date_time.strftime("%A") if start_time.date.nil?
      start_time = event.start.date if start_time.date_time.nil?
      start_time = start_time.date_time if event.start.date.nil?
      # Takes start and end times and converts them to a stringtime and sets an event range.
      event = start_time.strftime("%H:%M")..end_time.strftime("%H:%M")
      event_range = event.to_a
      # Similar to available_time this deletes any mintues over :59.
      event_range.delete_if do |time|
        time.split("")[3].to_i > 5
      end
      # The key of the acc is the day of the week i.e. "Wednesday"
      if !acc[weekday]
      # If this key has not been assigned then sets the availability to full availability
        available_times = available_time
      else
      # If this key has been assigned it sets available times to the existing value
        available_times = acc[weekday]
      end
      # Sets key to weekday and the value to available time minus the event time.
      acc[weekday] = [available_times - event_range].flatten
      acc
    end
  end

  # If there was not an event scheduled then that day will not be in the availability hash
  # This checks if it is present and if it's not sets the key to the weekday and availability to full availability
  def final_availability(availability)
    @weekdays.each do |weekday|
      availability[weekday] = available_time if !availability[weekday]
    end
    availability
  end

  # Grabs a random activity, time frame and date, checks if it is in open availability
  # and if it is returns those three items in an array.
  def create_random_date_and_activity
    open_slot = false
    activity = current_user.activities.sample(1).first
    if activity.nil?
      activity = "Yoga"
    else
      activity = activity.name
    end

    until open_slot
      day = @weekdays.sample(1).first
      time = hour_scheduled_times.sample(1)[0]
      user_availability = final_availability(availability)
      open_slot = time.to_a.all? { |num| user_availability[day].include?(num)}
      return [time.first, day, activity] if open_slot
    end
  end

  # Takes the random date and activity array and formats them for the google api.
  def event_details(create_random_date_and_activity)
    details = create_random_date_and_activity
    start_time = details[0].to_f
    day = details[1].to_datetime.new_offset('-0700')
    @start_date = (day + start_time.hour)
    @start_date + 1.week if @start_date > DateTime.now
    @end_date = (@start_date + 1.hour)
    @activity = details[2]
  end

  # Takes the formated details and inserts them into the google api event.new
  def event
    event_details(create_random_date_and_activity)

    EventSchedule.create!(event_name: @activity,
                      event_start_time: @start_date.to_f,
                      event_end_time: @end_date.to_f,
                      user_id: @current_user.id)
    @event = Google::Apis::CalendarV3::Event.new(
      summary: "Treat Yo Self to: #{@activity}",
      description: 'Treat Yo Self',

      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: @start_date.rfc3339,
         time_zone: 'America/Denver'
      ),

      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: @end_date.rfc3339,
        time_zone: 'America/Denver'
      ),

      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,

        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'email',
            minutes: 24 * 60
          ),

          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'popup',
            minutes: 24 * 60
          ),

          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'popup',
            minutes: 60
          )
        ]
      )
    )
    @event
  end

  # Takes the new  event details and inserts that event into the current user's calendar.
  def schedule_suggestions
    result = get_calendar_service.insert_event("primary", event)
  end
end
