class AddWatchersToMarketingRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :marketing_requests, :watchers, :string
  end
end
