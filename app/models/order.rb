class Order < ApplicationRecord
  belongs_to :origin
  belongs_to :destination
  belongs_to :client
  belongs_to :route
end
