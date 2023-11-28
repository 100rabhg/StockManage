class AddQuantityAndDamageToTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :types, :quantity, :integer
    add_column :types, :damage, :integer
  end
end
