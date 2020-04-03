class CreateCategoryActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :category_activities do |t|
      t.references :category, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
    end
  end
end
