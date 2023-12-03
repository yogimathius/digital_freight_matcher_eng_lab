# Engineering Lab 1 - Digital Freight Matching

## What is this API for?

See [Problem Statement](ProblemStatement.md) for more details

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Ruby 3.2.2 (use `rbenv` or `rvm` to install)
- Bundler (installed via `gem install bundler`)

## Getting Started

To get the project up and running on your local machine, follow these steps:

1. **Clone the Repository:**

   ```bash
   git clone git@github.com:yogimathius/digital_freight_matcher_eng_lab.git
   cd digital_freight_matcher_eng_lab
   ```

2. **Install Dependencies:**

   ```bash
   bundle install
   ```

3. **Database Setup:**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Run the Server:**

   ```bash
   rails server
   ```

   The application will be accessible at [http://localhost:3000](http://localhost:3000).

## Testing

For main test suite

```bash
bin/rails test
```

To run large batch tests with csv data:

```bash
RUN_LARGE_TEST_SUITE=1 bin/rails test
```

For model validation tests:

```bash
bundle exec rspec
```

## How To Use

This API is designed to receive orders in the following format:

### Order Structure

```
{
	cargo: {
    "packages": [1, 60, 'standard'] // CBM (vol.), weight (pounds), type
  },
	pick_up: {
    "latitude": 33.754413815792205,
    "longitude": -84.3875298776525
  },
  drop_off: {
    "latitude": 34.87433824316913,
    "longitude": -85.08447506395166
  }
}
```

To attempt adding an order to a route:

- using a REST client like [Postman](https://www.postman.com/) or [VSCode's REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client):

- make a `POST` request to `http://localhost:3000/orders` using the above [Order Structure](#order-structure) or CURL, if you wish
- if the order is within 1km proximity (using heron's formula, margin for error with large batch tests is ~0.2%) of a route's linear distance, the route can fit the order in it's shift duration and the truck has capacity for all of the packages, it will add the order to that route, and return the following data structure:

  ```
  {
      "message": "Success! adding to route #1, heading from Atlanta to Ringgold",
      "order": {
          "id": 6,
          "origin_id": 13,
          "destination_id": 14,
          "client_id": 6,
          "route_id": 1,
          "created_at": "2023-12-03T05:51:49.479Z",
          "updated_at": "2023-12-03T05:51:49.479Z",
          "backlog_id": null
      }
  }
  ```

- If no routes are found for the order, a generic response `No routes found` will be given
- If the order matches routes but the all route's shift duration have been maxed already, the following response will be given:

  ```
  {
    "message": "Shift duration maxed, adding to backlog",
    "order": {
        "id": 12,
        "origin_id": 25,
        "destination_id": 26,
        "client_id": 13,
        "route_id": 1,
        "created_at": "2023-12-03T06:15:53.454Z",
        "updated_at": "2023-12-03T06:15:53.454Z",
        "backlog_id": 1 // Notice backlog ID
    }
  }
  ```

- If the order matches routes but all truck capacity is full, the following response will be given:

  ```
  {
    "message": "Truck capacity maxed, adding to backlog",
    "order": {
        "id": 3,
        "origin_id": 7,
        "destination_id": 8,
        "client_id": 3,
        "route_id": 1,
        "created_at": "2023-12-03T06:17:56.344Z",
        "updated_at": "2023-12-03T06:17:56.344Z",
        "backlog_id": 1
    }
  }
  ```

- WIP: If the order contains a package with type `medicine`, or route contains `medicine` packages and `food` or `standard` is attempted to be mixed with `medicine` the following response will be given:

  ```
  {
    "message": "Current routes can't mix with medicine, adding to backlog",
    "order": {
        "id": 6,
        "origin_id": 13,
        "destination_id": 14,
        "client_id": 6,
        "route_id": null,
        "created_at": "2023-12-03T06:58:07.216Z",
        "updated_at": "2023-12-03T06:58:07.216Z",
        "backlog_id": 1
    }
  }
  ```

- order is always added to the backlog of the first matching route, which should be the most profitable
- truckers will take a 30 min break if shift duration exceeds 4 hours

### TODOS

- TODO: wire up check that pallets have been dropped before medicine can be picked up (have to test pickup, dropoff)
- TODO: Complete test coverage for major functions (97% currently, but not all methods are tested.. these are covered through parent functions and a significant amount of child functions were added as a burst refactor)
- TODO: Clear backlog after X amount of time? Queue backlog to next day's shifts?
- TODO: Fix failing tests ~11000 assertions with `RUN_LARGE_TEST_SUITE=1 bin/rails test`, and 30 failures. Some of these are due to inaccurate lat/long, some are due to triangular formula for proximity.
