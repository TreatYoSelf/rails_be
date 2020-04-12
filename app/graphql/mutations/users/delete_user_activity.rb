module Mutations
  module Users
    class DeleteUserActivity < ::Mutations::BaseMutation

      argument :id, ID, required: true
      argument :activity, String, required: true

      type Types::UserType

      def resolve(attributes)
        user = User.find(attributes[:id])
        activity = Activity.find_by(name: attributes[:activity])
        category_activity = CategoryActivity.find_by(activity_id: activity.id)

        user_activity = UserActivity.find_by(category_activity_id: category_activity.id)
        user_activity.destroy
        user
      end
    end
  end
end
