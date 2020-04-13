class Api::V1::UsersController < ApplicationController
	def create 
		user = User.create(user_params)
		if user.save
			session[:current_user] = user.id
		end
	end

	private 

	def user_params 
		params.permit(:first_name, :last_name, :email, :google_token)
	end
end