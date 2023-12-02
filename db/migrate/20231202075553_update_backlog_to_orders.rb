class UpdateBacklogToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :backlog, foreign_key: true
  end
end
