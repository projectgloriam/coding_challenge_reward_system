class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :invitee, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
