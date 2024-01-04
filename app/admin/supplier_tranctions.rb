ActiveAdmin.register SupplierTranction do

  permit_params :supplier_id, :debit_amount, :tranction_date
  
  form do |f|
    f.inputs do
      f.input :supplier_id, as: :select, collection: options_for_select(Supplier.all.map{|s|[s.name, s.id]}, selected: f.object.supplier_id)
      f.input :debit_amount
      f.input :tranction_date, as: :datepicker
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :supplier 
    column :buy_order
    column 'Credit Amount' do |tranction|
      number_to_currency(tranction.buy_order&.total_price, unit: '₹')
    end
    column :debit_amount do |tranction|
      number_to_currency(tranction.debit_amount, unit: '₹')
    end
    column :tranction_date
    column :actions do |tranction|
      raw(
          %(
            #{link_to 'View', admin_supplier_tranction_path(tranction)}
            #{link_to 'Delete', admin_supplier_tranction_path(tranction)}
            #{link_to 'Edit', edit_admin_supplier_tranction_path(tranction)}
          )
      ) if tranction.buy_order_id.nil?

    end
  end

  show do
    attributes_table do
      row :supplier
      row :debit_amount do |tranction|
        number_to_currency(tranction.debit_amount, unit: '₹')
      end
      row :tranction_date
    end
  end
end
