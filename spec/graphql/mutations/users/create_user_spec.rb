require 'rails_helper'

module Mutations
  module Users
    RSpec.describe CreateUser, type: :request do
      describe '.resolve' do
        it 'create a user' do
          expect(User.count).to eq(0)
          post '/graphql', params: { query: query }
          expect(User.count).to eq(1)
        end

        it 'returns a user' do
          post '/graphql', params: { query: query }
          json = JSON.parse(response.body)
          data = json['data']
          user = User.last
          expect(data["user"]["id"]).to eq(user.id.to_s)
          expect(data["user"]["firstName"]).to eq(user.first_name)
          expect(data["user"]["lastName"]).to eq(user.last_name)
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
    end
  end
end
