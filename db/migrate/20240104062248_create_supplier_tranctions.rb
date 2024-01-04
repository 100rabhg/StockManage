class CreateSupplierTranctions < ActiveRecord::Migration[7.0]
  def change
    create_table :supplier_tranctions do |t|
      t.references :supplier, foreign_key: true
      t.references :buy_order, foreign_key: true
      t.decimal :debit_amount
      t.datetime :tranction_date
      t.timestamps
    end
  end
end
