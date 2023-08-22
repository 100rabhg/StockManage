class BuyOrderItem < ApplicationRecord
  belongs_to :buy_order
  belongs_to :type
end
