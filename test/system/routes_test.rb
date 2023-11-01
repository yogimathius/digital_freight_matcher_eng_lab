require "application_system_test_case"

class RoutesTest < ApplicationSystemTestCase
  setup do
    @route = routes(:one)
  end

  test "visiting the index" do
    visit routes_url
    assert_selector "h1", text: "Routes"
  end

  test "should create route" do
    visit routes_url
    click_on "New route"

    fill_in "Anchor point", with: @route.anchor_point
    fill_in "Cargo cost", with: @route.cargo_cost
    fill_in "Contract name", with: @route.contract_name
    fill_in "Destination", with: @route.destination_id
    fill_in "Empty cargo cost", with: @route.empty_cargo_cost
    fill_in "Margin", with: @route.margin
    fill_in "Markup", with: @route.markup
    fill_in "Miles with cargo", with: @route.miles_with_cargo
    fill_in "Operational truck cost", with: @route.operational_truck_cost
    fill_in "Origin", with: @route.origin_id
    fill_in "Pallets", with: @route.pallets
    fill_in "Path", with: @route.path
    fill_in "Pickup dropoff qty", with: @route.pickup_dropoff_qty
    fill_in "Price based on cargo cost", with: @route.price_based_on_cargo_cost
    fill_in "Price based on total cost", with: @route.price_based_on_total_cost
    fill_in "Time hours", with: @route.time_hours
    fill_in "Total miles", with: @route.total_miles
    click_on "Create Route"

    assert_text "Route was successfully created"
    click_on "Back"
  end

  test "should update Route" do
    visit route_url(@route)
    click_on "Edit this route", match: :first

    fill_in "Anchor point", with: @route.anchor_point
    fill_in "Cargo cost", with: @route.cargo_cost
    fill_in "Contract name", with: @route.contract_name
    fill_in "Destination", with: @route.destination_id
    fill_in "Empty cargo cost", with: @route.empty_cargo_cost
    fill_in "Margin", with: @route.margin
    fill_in "Markup", with: @route.markup
    fill_in "Miles with cargo", with: @route.miles_with_cargo
    fill_in "Operational truck cost", with: @route.operational_truck_cost
    fill_in "Origin", with: @route.origin_id
    fill_in "Pallets", with: @route.pallets
    fill_in "Path", with: @route.path
    fill_in "Pickup dropoff qty", with: @route.pickup_dropoff_qty
    fill_in "Price based on cargo cost", with: @route.price_based_on_cargo_cost
    fill_in "Price based on total cost", with: @route.price_based_on_total_cost
    fill_in "Time hours", with: @route.time_hours
    fill_in "Total miles", with: @route.total_miles
    click_on "Update Route"

    assert_text "Route was successfully updated"
    click_on "Back"
  end

  test "should destroy Route" do
    visit route_url(@route)
    click_on "Destroy this route", match: :first

    assert_text "Route was successfully destroyed"
  end
end
