class SessionsController < ApplicationController
	def create
	 session[:current_user] = User.first.id
	end
end
