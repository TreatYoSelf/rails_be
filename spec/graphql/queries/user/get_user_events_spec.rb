require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find user events for today and last 6 days' do
		it 'can query a single user and return activities' do
			user = User.create(id: 111, first_name: "Sue", last_name: "Buckets", email: "suebuckets@gmail.com", google_token: "ya29.a0Ae4lvC2gRRgRnySKF8eFLj4kYHweZ4Nkq67Sdolpx_XajGHrv9FdP_qJ9ochyc_BE3wcceh5yV4We5Q4ou9EJRhPu4a1Yqvl8IuEoR3YAW6Z-SnGBjr3_CLrB709T70y_8DqiQ29CQ8Pp2zytU_WOcyx48cJkEuTYss" )
      category = Category.create(name: "Outdoors")

      activity = Activity.create(name: "Hike", est_time: "01:15")
      activity_1 = Activity.create(name: "Swimming", est_time: "01:15")
      category.activities << [activity, activity_1]
      x = CategoryActivity.all
      user.category_activities << x

      event_test = EventSchedule.create(event_name: activity.name, user_id: user.id, event_start_time: "2020-04-13 13:31:31 -0700", event_end_time: "2020-04-13 14:31:31 -0800", weekday: "Monday")
			result = TreatYoSelfSchema.execute(query).as_json
      binding.pry
      expect(result["data"]["getUserEvents"]["event"]).to eq(event_test)
		end
		def query
			<<~GQL
			{
				getUserEvents(id: "111")
				{ userEvents{
          eventName
        }
				}
			}
			GQL
		end
	end
end
