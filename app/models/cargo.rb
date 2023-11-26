# app/models/cargo.rb

class Cargo < ApplicationRecord
  belongs_to :order
  belongs_to :truck
  has_many :packages, dependent: :destroy

  accepts_nested_attributes_for :packages, allow_destroy: true
end
