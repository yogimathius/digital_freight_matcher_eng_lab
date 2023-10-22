class RemoveProfitabilityFromRoutes < ActiveRecord::Migration[7.0]
  def change
    remove_column :routes, :profitability
  end
end
