require 'rails_helper'

RSpec.describe "'/suggestions' endpoint", :vcr do
	it 'can get suggestions based on incoming params for a user' do
	user = create (:user)
	category = Category.create(name: "Outdoors")

	activity = Activity.create(name: "Hike", est_time: "01:15")
	activity_1 = Activity.create(name: "Swimming", est_time: "01:15")
	category.activities << [activity, activity_1]

	categoryactivities = CategoryActivity.all
	user.category_activities << categoryactivities
	#allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
		user_params = {
			category: ["outdoors", "mindfulness", "music"]
		}
		post "/api/v1/suggestions", params: user_params

		expect(response).to be_successful

		data = JSON.parse(response.body, symbolize_names: true)

		expect(data).to_not be_empty
	end
end
