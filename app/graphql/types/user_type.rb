module Types
	class UserType < Types::BaseObject
		field :id, ID, null: false
		field :first_name, String, null: false
		field :last_name, String, null: false
		field :email, String, null: false
		field :google_token, String, null: false
		field :activities, [String], null: true

		def activities
			object.activities.map do |activity|
				activity.name
			end
		end
	end
end
