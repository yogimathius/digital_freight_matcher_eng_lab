class Route < ApplicationRecord
  belongs_to :location, foreign_key: :origin_id
  belongs_to :location, foreign_key: :destination_id
end
