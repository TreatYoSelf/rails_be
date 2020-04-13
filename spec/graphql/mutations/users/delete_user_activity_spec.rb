require 'rails_helper'

module Mutations
  module Users

    RSpec.describe DeleteUserActivity, type: :request do

      it 'delete an activity belonging to a user' do
  			user = User.create(id: 115, first_name: "Sue", last_name: "Buckets", email: "suebuckets@gmail.com", google_token: "018723y4kjd" )
        category = Category.create(name: "Outdoors")

        activity1 = Activity.create(name: "Hike", est_time: "01:15")
        activity2 = Activity.create(name: "Bike Ride", est_time: "01:15")
        activity3 = Activity.create(name: "Facial", est_time: "01:15")
        activity4 = Activity.create(name: "Pedicure", est_time: "01:15")
        category.activities << [activity1, activity2, activity3, activity4]
        categoryactivities = CategoryActivity.all
        user.category_activities << categoryactivities

        expect(Activity.count).to eq(4)
        expect(user.category_activities.count).to eq(4)

  			result = TreatYoSelfSchema.execute(query).as_json

        # verifies that the activity is not deleted from database.
        expect(Activity.count).to eq(4)
        expect(user.category_activities.count).to eq(3)

        #array does not include activity 1 which should be deleted from user activities
        activities = [activity2.name, activity3.name, activity4.name]
        expect(result["data"]["user"]["activities"]).to eq(activities)

		  end
		def query
      <<~GQL
        mutation {
          user: deleteUserActivity(
            input: { id: "115"
                     activity: "Hike"
                      }  )
        {
          activities
          }
        }
      GQL
		end
    end
	end
end
