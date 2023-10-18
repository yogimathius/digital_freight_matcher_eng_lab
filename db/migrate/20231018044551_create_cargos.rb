class CreateCargos < ActiveRecord::Migration[7.0]
  def change
    create_table :cargos do |t|
      t.references :order, foreign_key: { to_table: 'orders' }
      t.references :truck, foreign_key: { to_table: 'trucks' }
      t.timestamps
    end
  end
end
