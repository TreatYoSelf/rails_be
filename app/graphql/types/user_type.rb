module Types
	class UserType < Types::BaseObject
		field :id, ID, null: false
		field :first_name, String, null: false
		field :last_name, String, null: false
		field :email, String, null: false
		field :google_token, String, null: false
		field :activities, [String], null: true
		field :event_schedules, [String], null: true

		def activities
			object.activities.map do |activity|
				activity.name
			end
		end

		def event_schedules
			object.event_schedules
		end
		# last_week = (Time.now - 1.week)
		# def events
		# 	recent_schedules = []
    #   last_week = (Time.now - 1.week)
    #   object.event_schedules.map do |event|
    #     event.created_at > last_week
		# 		recent_schedules << [event.event_name, event.weekday]
    #   end
		# 	recent_schedules
    # end
	end
end
