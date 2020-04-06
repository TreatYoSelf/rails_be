FactoryBot.define do 
	factory :category do 
		name { Faker::Dessert.variety }
		category_activity
		activity
	end
end