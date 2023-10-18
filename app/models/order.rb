class Order < ApplicationRecord
  belongs_to :location
  belongs_to :client
  belongs_to :route
end
