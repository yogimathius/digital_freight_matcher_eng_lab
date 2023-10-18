class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
       t.references :origin, foreign_key: { to_table: 'locations' }
       t.references :destination, foreign_key: { to_table: 'locations' }
       t.references :client, foreign_key: { to_table: 'clients' }
       t.references :route, foreign_key: { to_table: 'routes' }

      t.timestamps
    end
  end
end
