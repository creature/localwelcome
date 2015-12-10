class AddCapacityToEvent < ActiveRecord::Migration
  def change
    add_column :events, :capacity, :integer, default: 10
  end
end
