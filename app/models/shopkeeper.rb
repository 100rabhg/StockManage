class Shopkeeper < ApplicationRecord
  has_many :sell_orders, dependent: :destroy
  has_many :shopkeeper_tranctions, dependent: :destroy

  def balance
    balance = 0
    self.shopkeeper_tranctions.each do |tranction|
      if tranction.sell_order.present?
          balance += tranction.sell_order.total_price
      else
        balance -= tranction.credit_amount
      end
    end
    balance
  end
end
