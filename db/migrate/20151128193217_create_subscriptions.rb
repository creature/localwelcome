class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :chapter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
