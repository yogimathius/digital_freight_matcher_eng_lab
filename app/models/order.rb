# app/models/order.rb

class Order < ApplicationRecord
  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  belongs_to :client
  belongs_to :route, optional: true
  belongs_to :backlog, optional: true, foreign_key: { to_table: 'backlog' }, inverse_of: :orders

  has_one :cargo, dependent: :destroy

  accepts_nested_attributes_for :origin, :destination, :cargo, allow_destroy: true

  validates_associated :origin, :destination, :cargo
end
