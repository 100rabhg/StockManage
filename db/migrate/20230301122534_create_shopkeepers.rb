class CreateShopkeepers < ActiveRecord::Migration[7.0]
  def change
    create_table :shopkeepers do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :comment

      t.timestamps
    end
  end
end
