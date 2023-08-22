class BuyOrder < ApplicationRecord
  belongs_to :supplier, class_name: "Supplier"
  has_many :buy_order_items

  accepts_nested_attributes_for :buy_order_items

  # enum status: ['in-process', 'complete']
end
