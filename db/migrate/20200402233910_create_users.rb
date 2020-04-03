class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :google_token
      t.integer :self_care_time

      t.timestamps
    end
  end
end
