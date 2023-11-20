class RoutesController < ApplicationController
  before_action :set_route, only: %i[show edit update destroy]

  # GET /routes or /routes.json
  def index
    @routes = Route.all
  end

  # GET /routes/1 or /routes/1.json
  def show; end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit; end

  # POST /routes or /routes.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html do
          redirect_to route_url(@route),
                      notice: "Route was successfully created."
        end
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @route.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /routes/1 or /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html do
          redirect_to route_url(@route),
                      notice: "Route was successfully updated."
        end
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @route.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /routes/1 or /routes/1.json
  def destroy
    @route.destroy

    respond_to do |format|
      format.html do
        redirect_to routes_url, notice: "Route was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  def matching_routes
    unless valid_order?(order_params)
      render plain: 'Invalid order parameters', status: :unprocessable_entity
      return
    end

    # Find matching routes for proximity (within 1 km)
    matching_routes = get_matching_routes(order_params)

    unless matching_routes.any?
      render plain: 'No routes found', status: :unprocessable_entity
      return
    end

    # Check truck package capacity (make sure order doesn’t overload truck)
    # matching_routes = matching_routes.filter do |route|

    # end
    # Check truck shift duration (route doesn’t exceed 10 hrs)
    # matching_routes = matching_routes.filter do |route|

    # end

    render json: matching_routes, status: :ok
  end

  def valid_order?(order)
    !order.empty? &&
      !order[:pick_up].nil? &&
      !order[:cargo].nil? &&
      !order[:drop_off].nil?
  end

  def get_routes_in_range(order_params)
    pick_up_coords, drop_off_coords = OrderService.order_coords(order_params)

    matching_pick_up_route = Route.select do |route|
      OrderService.in_range?(pick_up_coords, route)
    end

    matching_drop_off_routes = Route.select do |route|
      OrderService.in_range?(drop_off_coords, route)
    end

    [matching_pick_up_route, matching_drop_off_routes]
  end

  def get_matching_routes(order_params)
    matching_pick_up_routes, matching_drop_off_routes = get_routes_in_range(order_params)

    matching_pick_up_routes.filter do |route|
      matching_drop_off_routes.map(&:id).include?(route.id)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_route
    @route = Route.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def route_params
    params.require(:route).permit(:origin_id, :destination_id, :path, :anchor_point, :miles_with_cargo, :total_miles, :operational_truck_cost, :pallets, :cargo_cost, :empty_cargo_cost, :markup,
                                  :price_based_on_total_cost, :price_based_on_cargo_cost, :margin, :pickup_dropoff_qty, :time_hours, :contract_name)
  end

  def order_params
    params.require(:order).permit(
      cargo: { packages: [] },
      pick_up: [:latitude, :longitude],
      drop_off: [:latitude, :longitude]
    )
  end
end
