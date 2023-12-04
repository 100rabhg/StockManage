class BuyOrder < ApplicationRecord
  belongs_to :supplier, class_name: "Supplier"
  has_many :buy_order_items, dependent: :destroy
  has_many :other_expenses, dependent: :destroy

  accepts_nested_attributes_for :buy_order_items, allow_destroy: true
  accepts_nested_attributes_for :other_expenses,  allow_destroy: true
  enum status: ['in-process', 'complete']

  before_save :total_price
  before_update :update_the_quantity

  
  def total_price
    other_expense_total_price = 0
    self.other_expenses.each do |p|
      other_expense_total_price = p.price + other_expense_total_price
    end
    self.total_price = price + other_expense_total_price
  end

  def update_the_quantity 
    if status == 'complete'
      type_ids = self.buy_order_items.pluck(:type_id)
      quan = self.buy_order_items.pluck(:quantity)
      type = Type.where(id: type_ids)
      type.each_with_index do |i, t|
        q = i.quantity + quan[t]
        i.update(quantity: q)
      end 
    end 
  end
end
