class CreateBuyOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :buy_order_items do |t|
      t.references :buy_order, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.integer :quantity
      t.string :comment

      t.timestamps
    end
  end
end
