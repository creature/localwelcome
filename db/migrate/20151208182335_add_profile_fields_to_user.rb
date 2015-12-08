class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :life_skills, :text
    add_column :users, :language_skills, :text
    add_column :users, :postcode, :string
  end
end
