class CreateOtherSellExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :other_sell_expenses do |t|
      t.string :name
      t.decimal :price
      t.references :sell_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
