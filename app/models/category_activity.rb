class CategoryActivity < ApplicationRecord
  belongs_to :categories
  belongs_to :activities
end
