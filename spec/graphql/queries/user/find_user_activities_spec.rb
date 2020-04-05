require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find user activities' do
		it 'can query a single user and return activities' do
			user = User.create(id: 111, first_name: "Sue", last_name: "Buckets", email: "suebuckets@gmail.com", google_token: "018723y4kjd" )
      category = Category.create(name: "Outdoors")

      activity = Activity.create(name: "Hike", est_time: "01:15")
      activity_1 = Activity.create(name: "Swimming", est_time: "01:15")
      category.activities << [activity, activity_1]

      x = CategoryActivity.all
      user.category_activities << x

			result = TreatYoSelfSchema.execute(query).as_json
      expect(result["data"]["findUserActivities"]["activities"]).to eq(["Hike", "Swimming"])
		end
		def query
			<<~GQL
			{
				findUserActivities(id: "111")
				{
					activities
				}
			}
			GQL
		end
	end
end
