class AddMoreInfoRequiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :more_info_required, :boolean, default: false
  end
end
