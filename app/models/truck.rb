class Truck < ApplicationRecord
  has_many :cargos, dependent: :destroy
  belongs_to :route
  
  def has_capacity?(cargo)
    binding.break
  end
end
