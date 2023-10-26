class AddRouteRelationToTrucks < ActiveRecord::Migration[7.0]
  def change
    add_reference(:trucks, :route)
  end
end
