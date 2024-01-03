class Shopkeeper < ApplicationRecord
  has_many :sell_orders, dependent: :destroy
end
