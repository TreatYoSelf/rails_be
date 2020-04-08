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
  calendar_id = "primary"
  response = service.list_events(calendar_id,
                                 max_results:   10,
                                 single_events: true,
                                 order_by:      "startTime",
                                 time_min:      DateTime.now.rfc3339)
    response.items.each do |event|
      start = event.start.date || event.start.date_time
      print "- #{event.summary} (#{start})"
    end
  end
end
