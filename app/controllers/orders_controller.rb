class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show; end

  # GET /orders/new
  def new
    @order = Order.new
    @order.build_origin
    @order.build_destination
    @cargo = @order.build_cargo
    @cargo.packages.build
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    matching_routes =
      Route.find_matching_routes_for_order(@order)

    unless matching_routes.any?
      render plain: 'No routes found', status: :unprocessable_entity
      return
    end

    response_data = check_order_eligible(matching_routes, @order)

    @order.client = Client.create!

    if @order.save
      render json: response_data, status: :ok
    else
      render plain: 'Failed to save order', status: :unprocessable_entity
    end
  end

  def check_order_eligible(matching_routes, order)
    found_route = matching_routes.first
    matching_routes = find_route(matching_routes, order)
    return add_to_backlog(order, found_route, "Current routes can't mix with medicine") unless matching_routes.any?

    found_route = matching_routes.first

    fits_in_shift = filter_routes_by_shift(matching_routes, order)
    return add_to_backlog(order, found_route, "Shift duration maxed") unless fits_in_shift.any?

    found_route = fits_in_shift.first

    has_capacity = filter_routes_by_capacity(fits_in_shift, order)
    return add_to_backlog(order, found_route, "Truck capacity maxed") unless has_capacity.any?

    found_route = has_capacity.first

    add_to_route(order, found_route)
  end

  def find_route(matching_routes, order)
    handle_medicine_case(matching_routes, order.cargo.packages.first.package_type)
  end

  def filter_routes_by_shift(routes, order)
    routes.filter { |route| route.fits_in_shift?(order) }
  end

  def filter_routes_by_capacity(routes, order)
    routes.filter { |route| route.truck.capacity?(order.cargo) }
  end

  def check_fits_in_shift(routes, order)
    fits_in_shift = routes.filter do |route|
      route.fits_in_shift?(order)
    end

    return add_to_backlog(order, found_route, "Shift duration maxed") unless fits_in_shift.any?

    fits_in_shift
  end

  def add_to_backlog(order, route, message)
    backlog = Backlog.find(route.backlog.id)
    backlog.orders << order
    order.update(backlog_id: backlog.id)
    { message: "#{message}, adding to backlog", order: @order }
  end

  def add_to_route(order, route)
    order.route = route

    order.cargo.truck = route.truck

    { message: "Success! adding to route ##{route.id}, heading from Atlanta to #{route.anchor_point}", order: order }
  end

  def handle_medicine_case(matching_routes, package_type)
    case package_type
    when 'medicine'
      matching_routes.filter(&:can_carry_medicine?)
    when 'food', 'standard'
      matching_routes.reject(&:can_carry_medicine?)
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    # @order = Order.find(order_params.)
    if @order.update(route_id: order_params_for_route)
      redirect_to order_url(@order), notice: "Order was successfully updated."
    else
      render plain: 'Failed to update order', status: :unprocessable_entity
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    permitted_params = params.require(:order).permit(
      cargo: [
        { packages: [] }
      ],
      pick_up: [:latitude, :longitude],
      drop_off: [:latitude, :longitude]
    )
    transform_params(permitted_params)
  end

  def transform_params(params)
    packages = [:volume, :weight, :package_type].zip(params[:cargo][:packages].map(&:to_s)).to_h

    {
      cargo_attributes: {
        packages_attributes: [packages]
      },
      origin_attributes: {
        latitude: params[:pick_up][:latitude].to_s,
        longitude: params[:pick_up][:longitude].to_s
      },
      destination_attributes: {
        latitude: params[:drop_off][:latitude].to_s,
        longitude: params[:drop_off][:longitude].to_s
      }
    }
  end

  def order_params_for_route
    params.require(:route_id)
  end
end
