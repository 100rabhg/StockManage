class AddQuantityAndDamageToTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :types, :quantity, :integer, default:0
    add_column :types, :damage, :integer, default:0
  end
end
