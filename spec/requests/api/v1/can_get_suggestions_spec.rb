require 'rails_helper'
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"

RSpec.describe "'/suggestions' endpoint" do
	it 'can get suggestions based on incoming params for a user', :vcr do

	token = ENV["GOOGLE_TOKEN"]
	user = User.create(first_name: 'Becky', last_name: 'Smith', email: 'bsmith@gmail.com', google_token: token)
	category = Category.create(name: "Outdoors")
	category2 = Category.create(name: "Mindfulness")

	activity = Activity.create(name: "Hike", est_time: "01:15")
	activity_1 = Activity.create(name: "Swimming", est_time: "01:15")
	activity_2 = Activity.create(name: "Yoga", est_time: "01:15")
	activity_3 = Activity.create(name: "Meditate", est_time: "01:15")
	activity_4 = Activity.create(name: "Shovel Snow", est_time: "01:15")
	category.activities << [activity, activity_1]
	category2.activities << [activity_2, activity_3]

	allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
 	allow(DateTime).to receive(:now).and_return(DateTime.parse('2020-04-13 13:31:31 -0700'))

		user_params = {
			category: ["Outdoors", "Mindfulness"]
		}

		post "/api/v1/suggestions", params: user_params

		expect(response).to be_successful
		expect(user.activities).to eq([activity, activity_1, activity_2, activity_3])
		expect(user.activities).not_to include(activity_4)
		data = JSON.parse(response.body, symbolize_names: true)
		expect(data[:scheduled_treat][:description]).to eq("Treat Yo Self")


	end
end
