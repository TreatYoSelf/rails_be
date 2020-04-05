module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :activities, [String], null: true

    def activities
      object.activities.map do |activity|
        activity.name
      end
    end
  end
end
