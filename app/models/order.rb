class Order < ApplicationRecord
  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  belongs_to :client
  belongs_to :route
  has_one :cargo, dependent: :destroy

  def build_order(order_params, route, client)
    ActiveRecord::Base.transaction do
      origin, destination = create_locations(order_params)

      order = Order.create!(
        origin_id: origin.id,
        destination_id: destination.id,
        client: client,
        route: route
      )

      cargo = Cargo.create!(
        order: order,
        truck: route.truck
      )
      create_packages(order_params[:cargo][:packages], cargo)
      order
    rescue ActiveRecord::RecordInvalid, StandardError => e
      Rails.logger.error(e)
    end
  end

  def create_packages(packages, cargo)
    packages.each do |package|
      Package.create!(
        volume: package[0],
        weight: package[1],
        package_type: package[2],
        cargo: cargo
      )
    end
  end

  def create_locations(order_params)
    origin = Location.create!(
      latitude: order_params[:pick_up][:latitude],
      longitude: order_params[:pick_up][:longitude]
    )

    destination = Location.create!(
      latitude: order_params[:drop_off][:latitude],
      longitude: order_params[:drop_off][:longitude]
    )
    [origin, destination]
  end
end
