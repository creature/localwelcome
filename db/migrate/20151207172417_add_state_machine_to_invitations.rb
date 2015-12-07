class AddStateMachineToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :aasm_state, :integer
    remove_column :invitations, :attending, :boolean
    remove_column :invitations, :invited, :boolean
    remove_column :invitations, :status, :integer
  end
end
