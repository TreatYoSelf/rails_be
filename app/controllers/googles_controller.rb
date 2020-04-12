class Api::V1::GooglesController < ApplicationController
  require "google/apis/calendar_v3"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "date"
  require "fileutils"
  def index
  # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Treat Yo Self"
    service.authorization = "ya29.a0Ae4lvC0H0GEBEE1IQYfPoqacV0RJMn_toLBIBz4DCL2kOK7_0lDbcshAzTdfLXRlJMwilm5Dzqa8la0CCyK82qBe8XBA9_I3j68N6XCSIPVXmthhwbHTZnMe6W-5G0lI9TCRqpLC94rPuPZyRK1ivBlij-EEgnVhbK3p"
    # Fetch the next 10 events for the user
    calendar_id = "primary"
    @response = service.list_events(calendar_id,
                                   time_min: DateTime.now.rfc3339,
                                   time_max: (DateTime.now + 1.month).rfc3339,
                                   single_events: true,
                                   order_by:      "startTime",
                                    max_results: 10)
  def available_time
    available_times = ("08:00".."20:00").to_a
    available_times.delete_if do |time|
     time.split("")[3].to_i > 5
    end
  end

  def event_range(event)
    event.to_a
    event.delete_if do |time|
      time.split("")[3].to_i > 5
    end
  end

  def availability
    @response.items.reduce({}) do |acc, event|
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

    @weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  def final_availability(availability)
    @weekdays.each do |day|
      availability[day] = available_time if !availability[day]
    end
  availability
  end

  @hour_scheduled_times = [("08:01".."08:59"), ("09:01".."09:59"),("10:01".."10:59"),("11:01".."11:59"),("12:01".."12:59"),( "13:01".."13:59"),( "14:01".."14:59"), ("15:01".."15:59"), ("16:01".."16:59"), ("17:01".."17.59"), ("18:01".."18:59"),( "19:01".."19:59"), ("20:01".."20:59")]

def find_open_time_slot
  open_slot = false
  until open_slot
    day = @weekdays.sample(1)[0]
    time = @hour_scheduled_times.sample(1)[0]
    user_availability = final_availability(availability)
    open_slot = time.to_a.all? { |num| user_availability[day].include?(num)}
    #time = [time.first]
    return [time.first, day] if open_slot
  end
end

x = find_open_time_slot
start_time = x[0].to_f
day = x[1].to_datetime
date = day + start_time.hour
require "pry"; binding.pry

#
    event = Google::Apis::CalendarV3::Event.new(
      summary: 'Google I/O 2015',
      location: 'activity',
      description: 'Treat Yo Self',
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: date.rfc3339,
        time_zone: 'America/Denver'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: date.rfc3339,
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
          )
        ]
      )
    )
  require "pry"; binding.pry
  result = service.insert_event("primary", event)
  end
end
