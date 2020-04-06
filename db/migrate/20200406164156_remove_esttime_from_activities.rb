class RemoveEsttimeFromActivities < ActiveRecord::Migration[6.0]
  def change
    remove_column :activities, :est_time, :time
    add_column :activities, :est_time, :integer
  end
end
