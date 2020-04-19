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
    service
  end

  # Uses Google Service to find a list of user events within current week time period
  def find_user_events
    calendar_id = "primary"
    response = get_calendar_service.list_events( calendar_id,
                                   time_min: Time.zone.now.to_datetime.new_offset('-0600').rfc3339,
                                   time_max: (Time.zone.now.to_datetime.new_offset('-0600') + 1.week).rfc3339,
                                   single_events: true,
                                   order_by: "startTime" )
  end

  # Sets available times from 8 a.m. - 8 p.m. as a string and puts that
  # in an array by the minute i.e. ["08:00", "08:01", "08:02"]
  def available_time(times)
    times.to_a.delete_if do |time|
     time.split("")[3].to_i > 5
    end
  end

  def format_scheduled_events(event)
    start_time = event.original_start_time
    start_time = event.start if event.original_start_time.nil?
    end_time = event.end.date_time if event.end.date.nil?
    end_time = event.end.date if event.end.date_time.nil?
    weekday = start_time.date.strftime("%A") if start_time.date_time.nil?
    weekday = start_time.date_time.strftime("%A") if start_time.date.nil?
    start_time = event.start.date if start_time.date_time.nil?
    start_time = start_time.date_time if event.start.date.nil?
    [start_time, end_time, weekday]
  end


  def availability
    find_user_events.items.reduce({}) do |acc, event|

      start_time = format_scheduled_events(event)[0]
      end_time = format_scheduled_events(event)[1]
      weekday = format_scheduled_events(event)[2]

      available_times = ("08:00".."20:00")
      event_time_range = start_time.strftime("%H:%M")..end_time.strftime("%H:%M")
      event_range = available_time(event_time_range)

      if !acc[weekday]
        available_times = available_time(available_times)
      else
        available_times = acc[weekday]
      end

      acc[weekday] = [available_times - event_range].flatten
      acc
    end
  end

  # If there was not an event scheduled then that day will not be in the availability hash
  # This checks if it is present and if it's not sets the key to the weekday and availability to full availability
  def final_availability(availability)
    available_times = ("08:00".."20:00")
    @weekdays.each do |weekday|
      availability[weekday] = available_time(available_times) if !availability[weekday]
    end
    availability
  end

  # Grabs a random activity, time frame and date, checks if it is in open availability
  # and if it is returns those three items in an array.
  def create_random_date_and_activity
    open_slot = false
    activity = current_user.activities.sample(1).first

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

    Time.zone = 'Mountain Time (US & Canada)'
    day = Date.strptime(details[1], '%A')
    day = day + 1.week if day < Time.zone.now.to_datetime.new_offset('-0600')
    @start_date  = day + (details[0].to_f.hour)
    @end_date = (@start_date + details[2].est_time.minutes)
    @activity = details[2].name
  end

  # Takes the formated details and inserts them into the google api event.new
  def event
    event_details(create_random_date_and_activity)

    @event = Google::Apis::CalendarV3::Event.new(
      summary: @activity,
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
