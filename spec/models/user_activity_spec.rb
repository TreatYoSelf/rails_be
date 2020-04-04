require 'rails_helper'

RSpec.describe UserActivity, type: :model do
	describe "Relationships" do 
		it {should belong_to :user}
		it {should belong_to :category_activity}
	end
end