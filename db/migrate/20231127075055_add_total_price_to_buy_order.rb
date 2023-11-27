class AddTotalPriceToBuyOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :buy_orders, :total_price, :decimal
  end
end
