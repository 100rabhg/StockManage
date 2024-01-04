class SellOrder < ApplicationRecord

  # shopkeeper -> references shopkeeper
  # price -> decimal
  # sell_date -> datetime
  # status -> ['in-process', 'complete']
  # total_price -> decimal

  belongs_to :shopkeeper
  has_many :sell_order_items, dependent: :destroy
  has_many :other_sell_expenses, dependent: :destroy
  has_one :shopkeeper_tranction, dependent: :destroy

  before_save :total_price
  before_save :price_calculate

  accepts_nested_attributes_for :sell_order_items, allow_destroy: true
  accepts_nested_attributes_for :other_sell_expenses,  allow_destroy: true

  after_create :remove_quantity_in_inventry
  before_update :sell_update_quantity
  after_update :create_tranction
   
  def create_tranction
    if self.shopkeeper_tranction.nil?
      self.shopkeeper_tranction= ShopkeeperTranction.new(shopkeeper: self.shopkeeper, tranction_date: self.sell_date)
    end
  end

  before_validation :validate_available_quantity


  def validate_available_quantity
    self.sell_order_items.each do |item|
      type = Type.find_by(id: item.type_id)
  
      if type.nil?
        errors.add(:base, "Invalid type for item #{item.id}")
      elsif item.quantity - (item.quantity_was.nil? ? 0 : item.quantity_was) > type.quantity
        errors.add(:base, "Insufficient quantity for type #{type.name}")
      end
    end
  end


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


  def sell_update_quantity
    self.sell_order_items.each do |sell_order_item|
      quantity_difference = sell_order_item.quantity -
      (sell_order_item.quantity_was.nil? ? 0 : sell_order_item.quantity_was)
      type = sell_order_item.type
      type.update(quantity: type.quantity - quantity_difference)
    end
  end

  def remove_quantity_in_inventry
    type_ids = self.sell_order_items.pluck(:type_id)
    quan = self.sell_order_items.pluck(:quantity)
    type = Type.where(id: type_ids)
    type.each_with_index do |i, t|
      q = i.quantity - quan[t] 
      i.update(quantity: q)
      
    end
    
  end

end
