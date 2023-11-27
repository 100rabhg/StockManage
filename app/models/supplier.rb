class Supplier < ApplicationRecord
  has_many :buy_orders, dependent: :destroy
end
