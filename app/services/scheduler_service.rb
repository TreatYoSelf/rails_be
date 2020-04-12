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

  def get_calendar_service
    service ||= Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Treat Yo Self"
    service.authorization = 'ya29.a0Ae4lvC0wiRoBsPoJOAF14smN7I1N0CJggSA7AriZKeWXlkTJ35cFE-2M3wWcLJBtgSPqx5LEwPQvDmaMIvZtPttThXV2rBdZOQ1aeVAnyVAj-8higHhspKH5Dj8Ed1lVsOKaIUFAHUmDkLGaPejH3e0r1DPDRWhLG1g'#@current_user.google_token
    service
  end

  def find_user_events
    calendar_id = "primary"
    response = get_calendar_service.list_events( calendar_id,
                                   time_min: DateTime.now.rfc3339,
                                   time_max: (DateTime.now + 1.week).rfc3339,
                                   single_events: true,
                                   order_by: "startTime" )
  end

  def available_time
    available_times = ("08:00".."20:00").to_a
    available_times.delete_if do |time|
     time.split("")[3].to_i > 5
    end
  end

  def availability
    find_user_events.items.reduce({}) do |acc, event|
      start_time = event.original_start_time
      start_time = event.start if event.original_start_time.nil?
      end_time = event.end.date_time

      if !acc[start_time.date_time.strftime("%A")]
        available_times = available_time
      else
        available_times = acc[start_time.date_time.strftime("%A")]
      end

      event = start_time.date_time.strftime("%H:%M")..end_time.strftime("%H:%M")
      event_range = event.to_a

      event_range.delete_if do |time|
        time.split("")[3].to_i > 5
      end
      acc[start_time.date_time.strftime("%A")] = [available_times - event_range].flatten
      acc
    end
  end

  def final_availability(availability)
    weekdays.each do |day|
      availability[day] = available_time if !availability[day]
    end
    availability
  end

  def create_random_date_and_activity
    open_slot = false
    activity = current_user.activities.sample(1).first
    until open_slot
      day = weekdays.sample(1)[0]
      time = hour_scheduled_times.sample(1)[0]
      user_availability = final_availability(availability)
      open_slot = time.to_a.all? { |num| user_availability[day].include?(num)}
      return [time.first, day, activity.name] if open_slot
    end
  end

  def event_details(create_random_date_and_activity)
    details = create_random_date_and_activity
    start_time = details[0].to_f
    day = details[1].to_datetime

    @start_date = (day + start_time.hour)
    @end_date = (@start_date + 1.hour).rfc3339
    @activity = details[2]
  end

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
        date_time: @end_date,
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
            minutes: 60
          ),

          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'popup',
            minutes: 60
          )
        ]
      )
    )
  end

  def schedule_suggestions
    result = get_calendar_service.insert_event("primary", event)
  end
end