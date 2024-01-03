class Type < ApplicationRecord
  has_many :buy_order_items,dependent: :destroy
  has_many :sell_order_items, dependent: :destroy

  before_update :damage_quantity

  def damage_quantity
    if new_record? || changes.include?('damage')
      updated_quantity = self.quantity - self.damage
      self.quantity = updated_quantity
    end
  end
  
end
