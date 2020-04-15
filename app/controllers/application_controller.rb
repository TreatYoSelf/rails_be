class ApplicationController < ActionController::API
	include ActionController::Helpers
	helper_method :current_user

	def current_user
		@current_user = User.find(1)
	#	@current_user ||= User.find(session[:current_user]) if session[:current_user]
	end
end
