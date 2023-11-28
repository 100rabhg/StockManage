ActiveAdmin.register SellOrder do

   permit_params :price,:total_price, :sell_date, :shopkeeper_id,
    sell_order_items_attributes: [:id, :sell_order_id, :type_id, :quantity, :price, :comment],
    other_sell_expenses_attributes: [:id, :name, :price]


    form do |f|
      f.inputs 'SellOrder Details' do
        f.input :shopkeeper_id, as: :select, collection: options_for_select(Shopkeeper.all.map{|s|[s.name, s.id]}, selected: f.object.shopkeeper_id)
        f.input :sell_date, as: :datepicker
      end
      f.inputs do
        f.has_many :sell_order_items, heading: 'SellOrder Item',
                                     allow_destroy: true do |item|
          item.input :type_id, as: :select, collection: options_for_select(Type.all.map{|t|[t.name, t.id]},  selected: item.object.type_id)
          item.input :quantity
          item.input :price
          item.input :comment
        end
      end
      f.inputs 'Other Sell Expenses' do
        f.has_many :other_sell_expenses, heading: 'Other Charge',
                                    allow_destroy: true do |item|
        item.input :name
        item.input :price
        end
      end
      actions 
    end

    index do
      selectable_column
      id_column
      column :shopkeeper do |sell_order|
        sell_order.shopkeeper.name
      end
      column 'Price' do |sell_order|
        number_to_currency(sell_order.price_calculate, unit: '₹')
      end
      column 'Total Price' do |sell_order|
        number_to_currency(sell_order.total_price, unit: '₹')
      end
      column :sell_date
      actions
    end

    show do
      attributes_table do
        row :shopkeeper do |sell_order|
          sell_order.shopkeeper.name
        end
        row 'Price(sell_item_price)' do |sell|
          number_to_currency(sell_order.price_calculate,unit: '₹')
        end
        row 'Total Price( with other_sell_expense)' do |sell_order|
          number_to_currency(sell_order.total_price, unit: '₹')
        end
        row :sell_date
      end
    
      panel 'Sell Items' do
        table_for sell_order.sell_order_items do
          column 'Type' do |item|
            item.type.name
          end
          column :quantity
          column  'price (per_qty.)' do |p|
            p.price 
          end
          column :comment
        end
      end
    
      panel 'Other Sell Expenses' do
        table_for sell_order.other_sell_expenses do
          column :name
          column :price
        end
      end
    end
end
