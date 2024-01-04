class SupplierTranction < ApplicationRecord

  # supplier  -> references supplier
  # buy_order -> references buy_order
  # debit_amount -> decimal
  # tranction_date -> date_time

  belongs_to :supplier
  belongs_to :buy_order, optional: true

  before_validation :validate_tranction

  def validate_tranction
    if self.buy_order.nil? && (self.debit_amount.nil? || self.debit_amount.zero?)
      errors.add(:tranction, 'invalid !')
    end
  end
end
