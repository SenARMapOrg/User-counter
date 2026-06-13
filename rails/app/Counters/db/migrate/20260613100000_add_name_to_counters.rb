class AddNameToCounters < ActiveRecord::Migration[8.1]
  def change
    add_column :counters, :name, :string, null: false, default: "(未設定)"
    add_index :counters, :name
  end
end
