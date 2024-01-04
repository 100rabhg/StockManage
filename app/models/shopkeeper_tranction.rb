class ShopkeeperTranction < ApplicationRecord
  # shopkeeper  -> references shopkeeper
  # sell_order -> references sell_order
  # credit_amount -> decimal
  # tranction_date -> date_time

  belongs_to :shopkeeper
  belongs_to :sell_order, optional: true

  before_validation :validate_tranction
  validates :tranction_date, presence: true
  validates :shopkeeper_id, presence: true

  def validate_tranction
    if self.sell_order.nil? && (self.credit_amount.nil? || self.credit_amount.zero?)
        errors.add(:credit_amount, "can't be blank")
    end
  end
end
