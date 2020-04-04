module Types
  class QueryType < Types::BaseObject
    field :get_user_google_token, Types::UserType, null: false, description: "returns user by google token" do
      argument :google_token, String, required: true
    end

    # resolvers below/controller actions
    def get_user_google_token(id:)
      binding.pry
      User.find_by(google_token: id)
    end
  end
end