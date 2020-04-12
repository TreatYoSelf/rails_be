require 'rails_helper'

RSpec.describe "'/suggestions' endpoint", :vcr do
	it 'can get suggestions based on incoming params for a user' do
	user = create (:user)
	category = Category.create(name: "Outdoors")
	category2 = Category.create(name: "Mindfulness")

	activity = Activity.create(name: "Hike", est_time: "01:15")
	activity_1 = Activity.create(name: "Swimming", est_time: "01:15")
	activity_2 = Activity.create(name: "Yoga", est_time: "01:15")
	activity_3 = Activity.create(name: "Meditate", est_time: "01:15")
	activity_4 = Activity.create(name: "Shovel Snow", est_time: "01:15")
	category.activities << [activity, activity_1]
	category2.activities << [activity_2, activity_3]
	#
	# categoryactivities = CategoryActivity.all
	# user.category_activities << categoryactivities

		user_params = {
			category: ["Outdoors", "Mindfulness"]
		}
		post "/api/v1/suggestions", params: user_params

		expect(response).to be_successful
			expect(user.activities).to eq([activity, activity_1, activity_2, activity_3])
			expect(user.activities).not_to include(activity_4)
			data = JSON.parse(response.body, symbolize_names: true)

			expect(data).to_not be_empty
	end
end
