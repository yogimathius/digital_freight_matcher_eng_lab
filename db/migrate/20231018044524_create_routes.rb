class CreateRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :routes do |t|
      t.references :origin, foreign_key: { to_table: 'locations' }
      t.references :destination, foreign_key: { to_table: 'locations' }
      t.float :profitability
      t.string :path

      t.timestamps
    end
  end
end
