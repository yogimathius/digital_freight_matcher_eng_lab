class UpdateLocations < ActiveRecord::Migration[7.0]
  def change
    change_column :locations, :geom, :point, spatial: true

  end
end
