require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:order1)

    @mock_order = {
      cargo: {
        packages: [1, 60, 'standard']
      },
      pick_up: {
        latitude: 33.754413815792205,
        longitude: -84.3875298776525
      },
      drop_off: {
        latitude: 34.87433824316913,
        longitude: -85.08447506395166
      }
    }
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order matching ringold route" do
    result = post orders_url, params: { order: @mock_order }

    ringold_route = Route.find(1)

    assert ringold_route, result
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  # test "should update order" do
  #   patch order_url(@order), params: { order: { client_id: @order.client_id, destination_id: @order.destination_id, origin_id: @order.origin_id, route_id: @order.route_id } }
  #   assert_redirected_to order_url(@order)
  # end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
