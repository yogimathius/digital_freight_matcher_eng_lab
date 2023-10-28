class Client < ApplicationRecord
  has_many :orders, dependent: :destroy
end
