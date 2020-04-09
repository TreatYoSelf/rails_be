require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find an activity' do
		it 'can get a single activity' do
      category = Category.create(id: 111, name: "Outdoors")
      activity1 = Activity.create(name: "Walk", est_time: 90)
      activity2 = Activity.create(name: "Hike", est_time: 180)
			activity3 = Activity.create(name: "Sit by the river", est_time: 30)
			joins1 = CategoryActivity.create(category_id: category.id, activity_id: activity1.id)
			joins2 = CategoryActivity.create(category_id: category.id, activity_id: activity2.id)
			joins3 = CategoryActivity.create(category_id: category.id, activity_id: activity3.id)



			result = TreatYoSelfSchema.execute(query).as_json
      expect(result["data"]["getDelights"].count).to eq(3)
    end
    def query
      <<~GQL
      {
        getDelights(id: "111")
        {
          id
          name
        }
      }
      GQL
    end
  end
end
