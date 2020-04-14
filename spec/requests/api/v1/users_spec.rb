require 'rails_helper'

describe 'create user and session' do
	it 'can create user and create session' do
		params = {
							"first_name": "tyla",
							"last_name": "smith",
              "email": "example@example.com",
							"google_token": "asdlkfuower3423",
							"google_refresh_token": "456245245424524"
             }

		post '/api/v1/users', params: params

		expect(response).to be_successful
		expect(User.count).to eq(1)
		user = User.first
		expect(user.first_name).to eq("tyla")
		expect(user.last_name).to eq("smith")

	end
end
