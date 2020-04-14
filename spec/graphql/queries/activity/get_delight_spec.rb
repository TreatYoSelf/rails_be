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

			category2 = Category.create(id: 112, name: "Mindfulness")
			activity_a = Activity.create(name: "Yoga", est_time: 90)
			activity_b = Activity.create(name: "Journaling", est_time: 180)
			activity_c = Activity.create(name: "Listen to David Arkenstone", est_time: 30)
			joins_a = CategoryActivity.create(category_id: category2.id, activity_id: activity_a.id)
			joins_b = CategoryActivity.create(category_id: category2.id, activity_id: activity_b.id)
			joins_c = CategoryActivity.create(category_id: category2.id, activity_id: activity_c.id)


			result = TreatYoSelfSchema.execute(query).as_json
			expect(result["data"]["getDelights"].count).to eq(3)
      expect(result["data"]["getDelights"].count).not_to eq(6)

			activity_1 = Activity.create(name: "Plant Trees", est_time: 90)
			activity_2 = Activity.create(name: "Rock Climbing", est_time: 180)
			activity_3 = Activity.create(name: "Sit in a Park", est_time: 30)
			joins1 = CategoryActivity.create(category_id: category.id, activity_id: activity_1.id)
			joins2 = CategoryActivity.create(category_id: category.id, activity_id: activity_2.id)
			joins3 = CategoryActivity.create(category_id: category.id, activity_id: activity_3.id)

			result = TreatYoSelfSchema.execute(query).as_json
			expect(result["data"]["getDelights"].count).to eq(5)
			expect(result["data"]["getDelights"].count).not_to eq(6)
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
