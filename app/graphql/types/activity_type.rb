module Types 
	class ActivityType < Types::BaseObject 
		field :id, ID, null: false
		field :name, String, null: false
		field :est_time, Integer, null: false
	end
end