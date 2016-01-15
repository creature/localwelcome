class AddWhoDoYouWantToMeetToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :who_do_you_want_to_meet, :text
  end
end
