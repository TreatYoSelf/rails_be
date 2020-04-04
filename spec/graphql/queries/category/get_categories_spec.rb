require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find all categories' do
		it 'change all the category types' do
      category1 = Category.create(name: "Outdoors")
      category2 = Category.create(name: "Indoors")
      category3 = Category.create(name: "Group")

      result = TreatYoSelfSchema.execute(query).as_json
      expect(result["data"]["getCategories"][0]["name"]).to eq("Outdoors")
      expect(result["data"]["getCategories"][1]["name"]).to eq("Indoors")
      expect(result["data"]["getCategories"][2]["name"]).to eq("Group")
    end
    def query
      <<~GQL
      {
        getCategories
        {
          name
        }
      }
      GQL
    end
  end
end
