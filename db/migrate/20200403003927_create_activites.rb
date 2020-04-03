class CreateActivites < ActiveRecord::Migration[6.0]
  def change
    create_table :activites do |t|
      t.string :name
      t.time :est_time

      t.timestamps
    end
  end
end
