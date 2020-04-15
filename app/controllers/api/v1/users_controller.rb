class Api::V1::UsersController < ApplicationController
	def create
		if User.find_by(email: params[:email]).nil?
			user = User.create(user_params)
			if user.save
				session[:current_user] = user.id
			end
		else
			user = User.find_by(email: params[:email])
			user.update(google_token: params[:google_token])
			session[:current_user] = user.id
		end
	end

	private

	def user_params
		params.permit(:first_name, :last_name, :email, :google_token, :google_refresh_token)
	end
end
