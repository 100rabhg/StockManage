class Supplier < ApplicationRecord
  has_many :buy_orders, dependent: :destroy
  has_many :supplier_tranctions, dependent: :destroy

  validates :phone_number, presence: true, 
                          numericality: true,
                          length: { is: 10 }

  def balance
    balance = 0
    self.supplier_tranctions.each do |tranction|
      if tranction.buy_order.present?
          balance += tranction.buy_order.total_price
      else
        balance -= tranction.debit_amount
      end
    end
    balance
  end
end
