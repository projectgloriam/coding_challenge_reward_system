class MakeUserColumnNullToInvite < ActiveRecord::Migration[7.0]
  def change
    change_column_null :invites, :user_id, :integer, null: true
  end
end
