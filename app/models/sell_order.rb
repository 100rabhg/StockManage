class SellOrder < ApplicationRecord
  belongs_to :shopkeeper
  has_many :sell_order_items
  has_many :other_sell_expenses, dependent: :destroy

  before_save :total_price
  before_save :price_calculate

  accepts_nested_attributes_for :sell_order_items
  accepts_nested_attributes_for :other_sell_expenses,  allow_destroy: true


 

  def total_price
    other_expense_total_price = 0
    price = price_calculate
    self.other_sell_expenses.each do |p|
      other_expense_total_price = p.price + other_expense_total_price
    end
    self.total_price = other_expense_total_price + price
  end

  def price_calculate
    sell_price = 0
    quantity = 0
    self.sell_order_items.each do |item|
      quantity += item.quantity
      sell_price += item.price * item.quantity
    end
    self.price = sell_price
  end

end
