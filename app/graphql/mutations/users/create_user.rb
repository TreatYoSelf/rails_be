module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :email, String, required: true
      argument :google_token, String, required: true

      type Types::UserType

      def resolve(attributes)
        user = User.create(attributes)
        require 'pry';binding.pry
        session[:user_id] = user.id
        user
      end
    end
  end
end
