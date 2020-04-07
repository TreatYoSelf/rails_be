require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find all categories' do
		it 'change all the category types' do
      category1 = Category.create(name: "Outdoors")
      category2 = Category.create(name: "Indoors")
      activity_1 = Activity.create(name: "Yoga", est_time: 60)
      activity_2 = Activity.create(name: "Bubble Bath", est_time: 60)
      activity_3 = Activity.create(name: "Meditate", est_time: 60)

      category2.activities << [activity_1, activity_2]
      category1.activities << activity_3

      result = TreatYoSelfSchema.execute(query).as_json

      expect(result["data"]["getCategoryActivities"]["activities"]).to eq(["Yoga", "Bubble Bath"])
      expect(result["data"]["getCategoryActivities"]["activities"]).not_to include("Meditate")
    end
    def query
      <<~GQL
      {
        getCategoryActivities(id: "Indoors" )
        {
          activities
        }
      }
      GQL
    end
  end
end
