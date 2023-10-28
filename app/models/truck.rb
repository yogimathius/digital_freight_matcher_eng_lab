class Truck < ApplicationRecord
  has_many :cargos, dependent: :destroy
end
