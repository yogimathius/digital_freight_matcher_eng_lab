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
    most_profitable_route =
      Route.find_matching_routes_for_order(@order)
    # binding.break
    @order.route = most_profitable_route.first

    @order.client = Client.create!
    @order.cargo.truck = most_profitable_route.first.truck
    @order.cargo.order = @order

    if @order.save
      render json: most_profitable_route, status: :ok
    else
      render plain: 'No routes found', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
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

  def order_param_two
    params.require(:order).permit(
      cargo_attributes: [
        :truck_id,
        { packages_attributes:
          [:volume, :weight, :package_type] }
      ],
      origin_attributes: [:latitude, :longitude],
      destination_attributes: [:latitude, :longitude]
    )
  end
end
