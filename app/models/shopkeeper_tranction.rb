class ShopkeeperTranction < ApplicationRecord
  # shopkeeper  -> references shopkeeper
  # sell_order -> references sell_order
  # credit_amount -> decimal
  # tranction_date -> date_time

  belongs_to :shopkeeper
  belongs_to :sell_order, optional: true

  before_validation :validate_tranction

  def validate_tranction
    if self.sell_order.nil? && (self.credit_amount.nil? || self.credit_amount.zero?)
      errors.add(:tranction, 'invalid !')
    end
  end
end
