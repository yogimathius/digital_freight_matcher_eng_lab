# app/models/package.rb

class Package < ApplicationRecord
  belongs_to :cargo

  validates :volume, presence: true, numericality: { greater_than: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :package_type, presence: true
end
