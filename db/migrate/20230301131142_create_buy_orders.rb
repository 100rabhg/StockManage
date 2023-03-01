class CreateBuyOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :buy_orders do |t|
      t.references :supplier, null: false, foreign_key: true
      t.decimal :price
      t.datetime :order_date
      t.datetime :delivery_date
      t.integer :status

      t.timestamps
    end
  end
end
