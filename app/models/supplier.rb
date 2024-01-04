class Supplier < ApplicationRecord
  has_many :buy_orders, dependent: :destroy
  has_many :supplier_tranctions, dependent: :destroy
end
