class CreateMarketingRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :marketing_requests do |t|
      t.string :title
      t.text :description
      t.integer :submitted_by_id
      t.string :workflow_state

      t.timestamps
    end
  end
end
