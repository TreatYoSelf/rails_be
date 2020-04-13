require 'rails_helper'

module Mutations
  module Users

    RSpec.describe CreateUserActivities, type: :request do

      it 'create a user and activities' do
  			user = User.create(id: 114, first_name: "Sue", last_name: "Buckets", email: "suebuckets@gmail.com", google_token: "018723y4kjd" )
        category = Category.create(name: "Outdoors")
        category2 = Category.create(name: "Spa")

        activity1 = Activity.create(name: "Hike", est_time: "01:15")
        activity2 = Activity.create(name: "Bike Ride", est_time: "01:15")
        activity3 = Activity.create(name: "Facial", est_time: "01:15")
        activity4 = Activity.create(name: "Pedicure", est_time: "01:15")
        category.activities << [activity1, activity2]
        category.activities << [activity3, activity4]


  			result = TreatYoSelfSchema.execute(query).as_json
        activities = [activity1.name, activity2.name, activity3.name, activity4.name]
        expect(result["data"]["user"]["activities"]).to eq(activities)
		  end
		def query
      <<~GQL
        mutation {
          user: createUserActivities(
            input: { id: "114"
                     categories: ["Outdoors", "Spa"]
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
