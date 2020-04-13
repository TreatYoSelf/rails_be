require 'rails_helper'

describe 'hello' do
		it 'returns a user' do
		create(:user)
		get '/hello'
		post '/graphql', params: { query: query }

		# require 'pry'; binding.pry
	end
	def query
		<<~GQL
			mutation {
				user: createUser(
					input: {
									firstName: "Becky"
									lastName: "Smith"
									email: "rer@gmail.com"
									googleToken: "34ete3t"
										}  )
			{
				id
				firstName
				lastName
				email
				}
			}
		GQL
	end
end
