class BuyOrderItem < ApplicationRecord
  belongs_to :buy_order
  belongs_to :type

  def status_is_complete?
    buy_order.status_is_complete?
  end

  before_destroy :update_type_quantity, if: :status_is_complete?

  def update_type_quantity
    previous_quantity = type.quantity
    type.update(quantity: previous_quantity - quantity)
  end
end
