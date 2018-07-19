class AddPriorityToMarketingRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :marketing_requests, :priority, :integer, default: 2
  end
end
