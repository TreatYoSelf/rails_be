module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::Users::CreateUser
    field :create_user_activities, mutation: Mutations::Users::CreateUserActivities
  end
end
