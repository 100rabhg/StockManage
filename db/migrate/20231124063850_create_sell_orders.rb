class CreateSellOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :sell_orders do |t|
      t.references :shopkeeper, null: false, foreign_key: true
      t.decimal :total_price
      t.datetime :sell_date
      

      t.timestamps
    end
  end
end
