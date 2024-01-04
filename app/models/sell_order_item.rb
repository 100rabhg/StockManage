class SellOrderItem < ApplicationRecord
  belongs_to :sell_order
  belongs_to :type

  before_destroy :update_type_quantity

  def update_type_quantity
    previous_quantity = type.quantity
    type.update(quantity: previous_quantity + quantity)
  end
end
