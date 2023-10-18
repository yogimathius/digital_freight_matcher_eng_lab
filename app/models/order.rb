class Order < ApplicationRecord
  belongs_to :location, foreign_key: :origin_id
  belongs_to :location, foreign_key: :destination_id
  belongs_to :client
  belongs_to :route
end
