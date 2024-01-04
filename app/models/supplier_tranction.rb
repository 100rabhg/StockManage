class SupplierTranction < ApplicationRecord

  # supplier  -> references supplier
  # buy_order -> references buy_order
  # debit_amount -> decimal
  # tranction_date -> date_time

  belongs_to :supplier
  belongs_to :buy_order, optional: true

  before_validation :validate_tranction
  validates :tranction_date, presence: true
  validates :supplier_id, presence: true

  def validate_tranction
    if self.buy_order.nil? && (self.debit_amount.nil? || self.debit_amount.zero?)
      errors.add(:debit_amount, "can't be blank")
    end
  end
end
