module Types
  class QueryType < Types::BaseObject
    field :get_user_google_token, Types::UserType, null: false, description: "returns user by google token" do
      argument :id, ID, required: true
    end

    field :find_user_activities, Types::UserType, null: false, description: "returns user activities" do
      argument :id, ID, required: true
    end

    # resolvers below/controller actions
    def get_user_google_token(id:)
      User.find_by(google_token: id)
    end

    def find_user_activities(id:)
      User.find(id)
    end
  end
end
