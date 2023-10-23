class Route < ApplicationRecord
  belongs_to :location, foreign_key: :destination_id, inverse_of: :routes
end
