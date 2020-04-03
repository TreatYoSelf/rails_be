class CreateUserActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :user_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category_activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
