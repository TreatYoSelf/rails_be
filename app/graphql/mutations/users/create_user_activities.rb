module Mutations
  module Users
    class CreateUserActivities < ::Mutations::BaseMutation
      argument :id, ID, required: true
      argument :categories, [String], required: true

      type Types::UserType

      def resolve(attributes)
        user = User.find(attributes[:id])

        category_ids = attributes[:categories].map do |name|
          category = Category.find_by(name: name)
          category.id
        end

        activities = CategoryActivity.where(category_id: [category_ids])
        user.category_activities << activities
        user
      end
    end
  end
end
