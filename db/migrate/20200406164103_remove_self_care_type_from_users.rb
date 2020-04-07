class RemoveSelfCareTypeFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :self_care_time, :interval
    add_column :users, :self_care_time, :integer
  end
end
