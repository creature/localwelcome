class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :chapter, index: true, foreign_key: true
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :description

      t.timestamps null: false
    end
  end
end
