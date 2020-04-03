class Category < ApplicationRecord
  validates_presence_of :name

  has_many :category_activities, dependent: :destroy
  has_many :activities, through: :category_activities
end
