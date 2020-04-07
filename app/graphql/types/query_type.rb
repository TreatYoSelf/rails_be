module Types
  class QueryType < Types::BaseObject
    field :get_user_google_token, Types::UserType, null: false, description: "returns user by google token" do
      argument :id, ID, required: true
    end

    field :get_categories, [Types::CategoryType], null: false, description: "returns all categories"

    field :get_user_activities, Types::UserType, null: false, description: "returns user activities" do
      argument :id, ID, required: true
    end


    field :get_category_activities, Types::CategoryType, null: false, description: "returns activities belonging to a category" do
      argument :id, ID, required: true
    end

    field :get_activities, [Types::ActivityType], null: false, description: "returns all categories"


    # resolvers below/controller actions

    def get_user_google_token(id:)
      User.find_by(google_token: id)
    end

    def get_categories
      Category.all
    end

    def get_user_activities(id:)
      User.find(id)
    end


    def get_category_activities(id:)
      Category.find_by(name: id)
    end 

    def get_activities 
      Activity.all
    end
  end
end
