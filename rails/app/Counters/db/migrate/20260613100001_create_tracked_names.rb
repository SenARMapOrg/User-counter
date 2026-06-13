class CreateTrackedNames < ActiveRecord::Migration[8.1]
  def change
    create_table :tracked_names do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tracked_names, :name, unique: true
  end
end
