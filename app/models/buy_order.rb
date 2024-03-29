class BuyOrder < ApplicationRecord

  # supplier -> > references supplier
  # price -> decimal
  # order_date -> datetime
  # delivery_date -> datetime
  # status -> ['in-process', 'complete']
  # total_price -> decimal

  belongs_to :supplier, class_name: "Supplier"
  has_many :buy_order_items, dependent: :destroy
  has_many :other_expenses, dependent: :destroy
  has_one :supplier_tranction, dependent: :destroy

  accepts_nested_attributes_for :buy_order_items, allow_destroy: true
  accepts_nested_attributes_for :other_expenses,  allow_destroy: true
  enum status: ['in-process', 'complete']

  validate :not_update_to_in_process_after_complete,

  def not_update_to_in_process_after_complete
    if status_was == 'complete' && (status == 'in-process' || status.nil?)
      errors.add(:status, "can't update to in-process and empty after compelete")
    end
  end

  before_save :total_price
  before_create :add_quantity_in_inventry, if: :status_is_complete?
  after_save :create_tranction, if: :status_is_complete?
  before_update :update_the_quantity, if: :status_is_complete?

  def status_is_complete?
    self.status == 'complete'
  end

  def create_tranction
    if self.supplier_tranction.nil?
      self.supplier_tranction= SupplierTranction.new(supplier: self.supplier, tranction_date: self.delivery_date)
    end
  end

  def total_price
    other_expense_total_price = 0
    self.other_expenses.each do |p|
      other_expense_total_price = p.price + other_expense_total_price
    end
    self.total_price = price + other_expense_total_price
  end

  def update_the_quantity
    if self.status_was == 'complete'
      self.buy_order_items.each do |buy_order_item|
        quantity_difference = buy_order_item.quantity - 
        (buy_order_item.quantity_was.nil? ? 0 : buy_order_item.quantity_was)
        type = buy_order_item.type
        type.update(quantity: type.quantity + quantity_difference)
      end
    else
      add_quantity_in_inventry
    end
  end

  def add_quantity_in_inventry
    self.buy_order_items.each do |buy_order_item|
      quan = buy_order_item.quantity
      type = buy_order_item.type
      type.update(quantity: type.quantity + quan)
    end
  end
end
