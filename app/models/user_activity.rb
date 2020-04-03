class UserActivity < ApplicationRecord
  belongs_to :user
  belongs_to :category_activity
end
