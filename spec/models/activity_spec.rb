require 'rails_helper'

RSpec.describe Activity, type: :model do
	describe "Validations" do 
		it {should validate_presence_of :name}
		it {should validate_presence_of :est_time}
	end

	describe "Relationships" do 
		it {should have_many :category_activities}
		it {should have_many(:categories).through(:category_activities)}
	end
end