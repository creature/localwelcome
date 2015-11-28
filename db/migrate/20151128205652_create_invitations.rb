class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.boolean :invited
      t.boolean :attending
      t.integer :status

      t.timestamps null: false
    end
  end
end
