class RenameActivitesToActivities < ActiveRecord::Migration[6.0]
  def change
    rename_table :activites, :activities
  end
end
