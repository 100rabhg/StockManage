class BuyOrder < ApplicationRecord
  belongs_to :supplier, class_name: "Supplier"
  has_many :buy_order_items, dependent: :destroy
  has_many :other_expenses, dependent: :destroy

  accepts_nested_attributes_for :buy_order_items, allow_destroy: true
  accepts_nested_attributes_for :other_expenses,  allow_destroy: true
  enum status: ['in-process', 'complete']


  def total_price
    price + other_expenses.sum(:price)
  end

end
