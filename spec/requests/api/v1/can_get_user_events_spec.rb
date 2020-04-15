require 'rails_helper'
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"

RSpec.describe "'/users/events' endpoint" do
	it 'can get events from params for a user', :vcr do

		token = ENV["GOOGLE_TOKEN"]
		user = User.create(first_name: 'Tyla', last_name: 'Smith', email: 'example@example.com', google_token: token)
		category = Category.create(name: "Outdoors")

		activity = Activity.create(name: "Hike", est_time: "01:15")
		activity_1 = Activity.create(name: "Swimming", est_time: "01:15")

		category.activities << [activity, activity_1]

		time = DateTime.now.to_f
		event = EventSchedule.create(event_name: activity.name, event_start_time: time, event_end_time: time, weekday: "Monday", user_id: user.id)
		event_1 = EventSchedule.create(event_name: activity_1.name, event_start_time: time, event_end_time: time, weekday: "Monday", user_id: user.id)
		
		user.reload
		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)


		get "/api/v1/users/events"

		expect(response).to be_successful

		data = JSON.parse(response.body)
		expect(data["events"][0]["event_name"]).not_to be_empty
		expect(data["events"][1]["event_name"]).not_to be_empty
	end
end
