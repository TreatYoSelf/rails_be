require 'rails_helper'

RSpec.describe "'/suggestions' endpoint" do
	it 'can get suggestions based on incoming params for a user' do 
		user_params = {
			user_id: 1, 
			user_name: "Tyla",
			est_time: 90,
			category: ["outdoors", "mindfulness", "music"]
		}
		post "/api/v1/suggestions", params: user_params

		expect(response).to be_successful

		data = JSON.parse(response.body, symbolize_names: true)
		expect(data).to_not be_empty
	end
end