class User < ApplicationRecord
validates_presence_of :first_name, :last_name, :google_token
validates :email, uniqueness: true

has_many :event_schedules, dependent: :destroy
has_many :user_activities, dependent: :destroy
has_many :category_activities, through: :user_activities
has_many :activities, through: :category_activities
end
