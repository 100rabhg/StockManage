class SellOrderItem < ApplicationRecord
  belongs_to :sell_order
  belongs_to :type
end
