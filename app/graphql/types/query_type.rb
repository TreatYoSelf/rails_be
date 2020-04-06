module Types
  class QueryType < Types::BaseObject
    field :get_user_google_token, Types::UserType, null: false, description: "returns user by google token" do
      argument :id, ID, required: true
    end

    field :get_categories, [Types::CategoryType], null: false, description: "returns all categories"

    # resolvers below/controller actions
    
    def get_user_google_token(id:)
      User.find_by(google_token: id)
    end

    def get_categories
      Category.all
    end
  end
end