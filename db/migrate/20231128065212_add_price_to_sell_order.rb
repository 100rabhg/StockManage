class AddPriceToSellOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :sell_orders, :price, :decimal
  end
end
