class AddRewardColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reward, :float
  end
end
