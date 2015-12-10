class AddAnnouncedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :announced, :boolean
  end
end
