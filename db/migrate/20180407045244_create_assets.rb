class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.integer :assetable_id
      t.string :assetable_type
      t.attachment :attachment
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :assets, [:assetable_type, :assetable_id]
  end
end
