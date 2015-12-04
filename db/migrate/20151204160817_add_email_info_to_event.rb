class AddEmailInfoToEvent < ActiveRecord::Migration
  def change
    add_column :events, :email_info, :text
  end
end
