require 'rails_helper'

RSpec.describe User, type: :model do
	describe "Validations" do 
		it {should validate_presence_of :first_name}
		it {should validate_presence_of :last_name}
		it {should validate_presence_of :google_token}
		it {should validate_presence_of :self_care_time}
	end

	describe "Relationships" do 
		it {should have_many :user_activities}
		it {should have_many(:category_activities).through(:user_activities)}
	end
end