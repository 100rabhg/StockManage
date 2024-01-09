class Shopkeeper < ApplicationRecord
  has_many :sell_orders, dependent: :destroy
  has_many :shopkeeper_tranctions, dependent: :destroy

  validates :phone_number, presence: true, 
                          numericality: true,
                          length: { minimum: 10, maximum: 15 }

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

  def last_payment_older_than_or_no_payment?(time)
    tranctions = shopkeeper_tranctions.where(sell_order: nil).order(tranction_date: :desc)
    if tranctions.present?
      return tranctions.first.tranction_date <= Date.today - time
    else
      sell_orders.order(sell_date: :desc).first.sell_date <= Date.today - time
    end
  end
end
