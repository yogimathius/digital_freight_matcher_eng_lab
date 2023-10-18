class CreateTrucks < ActiveRecord::Migration[7.0]
  def change
    create_table :trucks do |t|
      t.boolean :autonomy
      t.integer :capacity
      t.string :truck_type

      t.timestamps
    end
  end
end
