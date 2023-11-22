ActiveAdmin.register BuyOrder do

  permit_params :supplier_id,
                :price,
                :order_date,
                :delivery_date,
                :status,
                buy_order_items_attributes: [:id, :buy_order_id, :type_id, :quantity, :comment]

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
        item.input :type_id, as: :select, collection: options_for_select(Type.all.map{|t|[t.name, t.id]})
        item.input :quantity
        item.input :comment
      end
    end
    actions
  end
  
end
