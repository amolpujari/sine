class AddUuidToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :uuid, :string, index: true
    Asset.all.each{|a| a.uuid = SecureRandom.uuid; a.save(validate: false) } 
  end
end
