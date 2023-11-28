class CreateSellOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :sell_order_items do |t|
      t.references :sell_order, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.string :comment

      t.timestamps
    end
  end
end
