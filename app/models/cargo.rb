class Cargo < ApplicationRecord
  belongs_to :order
  belongs_to :truck
end
