require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:order1)
    @order2 = orders(:order2)

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
    post orders_url, params: { order: @mock_order }

    ringold_route = Route.find(1)

    assert_response 200

    assert_equal ringold_route.to_json, response.body
  end

  test "should fail to create order if no matching routes" do
    unmatching_order = {
      cargo: {
        packages: [1, 60, 'standard']
      },
      pick_up: {
        latitude: 33.74724197037782,
        longitude: -84.39022107905394
      },
      drop_off: {
        latitude: 33.713341098350774,
        longitude: -84.39685563810957
      }
    }

    post orders_url, params: { order: unmatching_order }

    assert_response :unprocessable_entity
    assert_equal 'No routes found', response.body.strip
  end

  test "create should render error message on failure to save order" do
    # Set up your order_params here based on your application requirements
    order_params = {
      cargo: {
        packages: [1, "not a number", 'standard']
      },
      pick_up: {
        latitude: 33.74724197037782,
        longitude: -84.39022107905394
      },
      drop_off: {
        latitude: 34.87433824316913,
        longitude: -85.08447506395166
      }
    }

    post orders_url, params: { order: order_params }

    assert_response :unprocessable_entity
    assert_equal 'Failed to save order', response.body
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order with new route id" do
    patch order_url(@order), params: { route_id: 2 }
    @order.reload

    assert_redirected_to order_url(@order)
    assert_equal 2, @order.route_id
  end

  test "should fail to update order with unmatching route id" do
    patch order_url(@order), params: { route_id: 22 }
    @order.reload

    assert_response :unprocessable_entity
    assert_equal 'Failed to update order', response.body.strip
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
