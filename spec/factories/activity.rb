FactoryBot.define do 
	factory :activity do 
		name { Faker::Dessert.variety}
		category 
		category_activity
	end
end