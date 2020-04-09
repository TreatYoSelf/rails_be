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
  service.authorization = current_user.google_token
  # Fetch the next 10 events for the user
  # calendar_id = "primary"
  # response = service.list_events(calendar_id,
  #                                max_results:   10,
  #                                single_events: true,
  #                                order_by:      "startTime",
  #                                time_min:      DateTime.now.rfc3339)
  #
  #   response.items.each do |event|
  #     start = event.start.date || event.start.date_time
  #     print "- #{event.summary} (#{start})"
  #   end

    event = Google::Apis::CalendarV3::Event.new(
      summary: 'Google I/O 2015',
      location: '800 Howard St., San Francisco, CA 94103',
      description: 'A chance to hear more about Google\'s developer products.',
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2015-05-28T09:00:00-07:00',
        time_zone: 'America/Los_Angeles'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2015-05-28T17:00:00-07:00',
        time_zone: 'America/Los_Angeles'
      ),
      recurrence: [
        'RRULE:FREQ=DAILY;COUNT=2'
      ],
      attendees: [
        Google::Apis::CalendarV3::EventAttendee.new(
          email: 'lpage@example.com'
        ),
        Google::Apis::CalendarV3::EventAttendee.new(
          email: 'sbrin@example.com'
        )
      ],
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'email',
            minutes: 24 * 60
          ),
          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'popup',
            minutes: 10
          )
        ]
      )
    )

require "pry"; binding.pry
client = Signet::OAuth2::Client.new(client_options)
    result = client.insert_event('primary', event)
    puts "Event created: #{result.html_link}"

    # conn = Faraday.new(url: "https://www.googleapis.com") do |faraday|
    #   faraday.headers["Authorization"] = 'Bearer '
    #   faraday.adapter Faraday.default_adapter
    # end
    # key = ENV["GOOGLE_API_KEY"]
    # date = {"end": {"date": "2020-05-28"}, "start": {"date": "2020-05-28"}}
    # id = "primary"
    # response = conn.post("/calendar/v3/calendars/#{id}/events?key=#{key}"), date.to_json
    #
    # require "pry"; binding.pry
    # body = JSON.parse(response.body)
  end

  def client_options
    {
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      authorization_uri: ENV["authorization_uri"],
      token_credential_uri: ENV["token_uri"],
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: ENV['redirect_uri']
    }
  end
end
