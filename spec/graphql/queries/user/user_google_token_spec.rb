require 'rails_helper'

RSpec.describe Types::QueryType do
	describe 'find user' do
		it 'can query a single user by google token' do
			user = User.create(first_name: "Sue", last_name: "Buckets", email: "suebuckets@gmail.com", google_token: "018723y4kjd" )
			result = TreatYoSelfSchema.execute(query).as_json
			expect(result["data"]["getUserGoogleToken"]["firstName"]).to eq("Sue")
			expect(result["data"]["getUserGoogleToken"]["lastName"]).to eq("Buckets")
			expect(result["data"]["getUserGoogleToken"]["email"]).to eq("suebuckets@gmail.com")
		end
		def query
			<<~GQL
			{
				getUserGoogleToken(id: "018723y4kjd")
				{
					firstName
					lastName
					email
					googleToken
				}
			}
			GQL
		end
	end
end
