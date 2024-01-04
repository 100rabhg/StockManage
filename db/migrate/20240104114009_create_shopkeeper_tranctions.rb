class CreateShopkeeperTranctions < ActiveRecord::Migration[7.0]
  def change
    create_table :shopkeeper_tranctions do |t|
      t.references :shopkeeper, foreign_key: true
      t.references :sell_order, foreign_key: true
      t.decimal :credit_amount
      t.datetime :tranction_date
      t.timestamps
    end
  end
end
