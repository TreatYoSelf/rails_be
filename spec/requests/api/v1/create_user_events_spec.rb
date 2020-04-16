require 'rails_helper'
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"

RSpec.describe "/suggestions endpoint", :vcr do

	it 'can make events for a user' do
	token = ENV["G_T"]
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

  user.category_activities << CategoryActivity.all
	allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
 	allow(DateTime).to receive(:now).and_return(DateTime.parse('2020-04-13 13:31:31 -0700'))

    get "/api/v1/suggestions"

		expect(response).to be_successful

		data = JSON.parse(response.body)
	end
end
