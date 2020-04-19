class AddToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :g_t, :string
    add_column :users, :google_token, :string
  end
end
