class AddContractNameToRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :contract_name, :string
  end
end
