require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find all activities' do
		it 'change all the activity types' do
			category = Category.create(name: "Outdoors")
      activity1 = Activity.create(name: "Walk")
      activity2 = Activity.create(name: "Hike")
			activity3 = Activity.create(name: "Sit by the river")
			joins1 = CategoryActivity.create(category_id: category.id, activity_id: activity1.id)
			joins2 = CategoryActivity.create(category_id: category.id, activity_id: activity2.id)
			joins3 = CategoryActivity.create(category_id: category.id, activity_id: activity3.id)
			

			result = TreatYoSelfSchema.execute(query).as_json
			
      expect(result["data"]["getActivities"][0]["name"]).to eq("Walk")
      expect(result["data"]["getActivities"][1]["name"]).to eq("Hike")
      expect(result["data"]["getActivities"][2]["name"]).to eq("Sit by the river")
    end
    def query
      <<~GQL
      {
        getActivities
        {
          name
        }
      }
      GQL
    end
  end
end
