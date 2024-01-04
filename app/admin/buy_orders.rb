ActiveAdmin.register BuyOrder do

  permit_params :supplier_id,
                :price,
                :total_price,
                :order_date,
                :delivery_date,
                :status,
                buy_order_items_attributes: [:id, :buy_order_id, :type_id, :quantity, :comment, :_destroy],
                other_expenses_attributes: [:id, :name, :price, :_destroy]


  form do |f|
    f.inputs 'Order Details' do
      f.input :supplier_id, as: :select, collection: options_for_select(Supplier.all.map{|s|[s.name, s.id]}, selected: f.object.supplier_id)
      f.input :price
      f.input :order_date, as: :datepicker
      f.input :delivery_date, as: :datepicker
      f.input :status, as: :select, collection: options_for_select(["in-process", "complete"], selected: f.object.status)
    end
    f.inputs do
      f.has_many :buy_order_items, heading: 'Order Item',
                                   allow_destroy: true do |item|
        item.input :type_id, as: :select, collection: options_for_select(Type.all.map{|t|[t.name, t.id]},  selected: item.object.type_id)
        item.input :quantity
        item.input :comment
      end
    end
      f.inputs 'Other Expenses' do
        f.has_many :other_expenses, heading: 'Other Charge',
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
    column :supplier do |buy_order|
      buy_order.supplier.name
    end
    column :price do |buy_order|
      number_to_currency(buy_order.price, unit: '₹')
    end
    column 'Total Price' do |buy_order|
      number_to_currency(buy_order.total_price, unit: '₹')
    end
    column :order_date
    column :delivery_date
    column :status
    actions
  end

  show do
    attributes_table do
      row :supplier do |buy_order|
        buy_order.supplier.name
      end
      row :price do |buy_order|
        number_to_currency(buy_order.price, unit: '₹')
      end
      row 'Total Price(price + other_expense)' do |buy_order|
        number_to_currency(buy_order.total_price, unit: '₹')
      end
      row :order_date
      row :delivery_date
      row :status
    end
  
    panel 'Order Items' do
      table_for buy_order.buy_order_items do
        column 'Type' do |item|
          item.type.name
        end
        column :quantity
        column :comment
      end
    end
  
    panel 'Other Expenses' do
      table_for buy_order.other_expenses do
        column :name
        column :price do |other_expense|
          number_to_currency(other_expense.price, unit: '₹')
        end
      end
    end
  end
end

