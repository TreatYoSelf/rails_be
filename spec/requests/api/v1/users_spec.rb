require 'rails_helper'

describe 'create user and session' do
	it 'can create user and create session' do
		params = {
							"first_name": "tyla",
							"last_name": "smith",
              "email": "example@example.com",
							"google_token": "asdlkfuower3423"
             }

		post '/api/v1/users', params: params
		expect(response).to be_successful
		data = JSON.parse(response.body, symbolize_names: true)
		require 'pry'; binding.pry
		expect(data[:first_name])
	end
end

		# get '/hello'
		# post '/graphql', params: { query: query }

# def query
# 		<<~GQL
# 			mutation {
# 				user: createUser(
# 					input: {
# 									firstName: "Becky"
# 									lastName: "Smith"
# 									email: "rer@gmail.com"
# 									googleToken: "34ete3t"
# 										}  )
# 			{
# 				id
# 				firstName
# 				lastName
# 				email
# 				}
# 			}
# 		GQL
# 	end