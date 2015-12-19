class AddVenueInfoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :venue_name, :string
    add_column :events, :venue_postcode, :string
    add_column :events, :venue_info, :text
  end
end
