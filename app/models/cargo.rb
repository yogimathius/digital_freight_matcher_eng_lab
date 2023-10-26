class Cargo < ApplicationRecord
  belongs_to :order
  belongs_to :truck
  has_many :packages, dependent: :destroy
end
