class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.integer :volume
      t.integer :weight
      t.string :package_type
      t.references :cargo, foreign_key: { to_table: 'cargos' }

      t.timestamps
    end
  end
end
