class AddSpatialColumnsToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :geom, :point, geographic: true

    # Optional: You can remove the old latitude and longitude columns
    remove_column :locations, :latitude
    remove_column :locations, :longitude
  end
end
