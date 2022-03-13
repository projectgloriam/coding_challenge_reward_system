class AddConfirmColumnToInvites < ActiveRecord::Migration[7.0]
  def change
    add_column :invites, :confirm, :boolean
  end
end
