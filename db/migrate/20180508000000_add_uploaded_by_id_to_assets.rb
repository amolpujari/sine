class AddUploadedByIdToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :uploaded_by_id, :integer, index: true
  end
end
