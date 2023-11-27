class Type < ApplicationRecord
  has_many :buy_order_items,dependent: :destroy
  has_many :sell_order_items, dependent: :destroy
end
