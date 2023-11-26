# app/models/cargo.rb

class Cargo < ApplicationRecord
  belongs_to :order
  belongs_to :truck
  has_many :packages, dependent: :destroy

  accepts_nested_attributes_for :packages, allow_destroy: true

  validates :order_id, presence: true
  validates :truck_id, presence: true
end
