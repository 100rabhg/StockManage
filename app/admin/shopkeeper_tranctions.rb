ActiveAdmin.register ShopkeeperTranction do

  permit_params :shopkeeper_id, :credit_amount, :tranction_date

  form do |f|
    f.inputs do
      f.input :shopkeeper_id, as: :select, collection: options_for_select(Shopkeeper.all.map{|s|[s.name, s.id]}, selected: f.object.shopkeeper_id)
      f.input :credit_amount
      f.input :tranction_date, as: :datepicker
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :shopkeeper 
    column :sell_order
    column 'Debit Amount' do |tranction|
      number_to_currency(tranction.sell_order&.total_price, unit: '₹')
    end
    column :credit_amount do |tranction|
      number_to_currency(tranction.credit_amount, unit: '₹')
    end
    column :tranction_date
    column :actions do |tranction|
      raw(
          %(
            #{link_to 'View', admin_shopkeeper_tranction_path(tranction)}
            #{link_to 'Delete', admin_shopkeeper_tranction_path(tranction)}
            #{link_to 'Edit', edit_admin_shopkeeper_tranction_path(tranction)}
          )
      ) if tranction.sell_order_id.nil?

    end
  end

  show do
    attributes_table do
      row :shopkeeper
      row :credit_amount do |tranction|
        number_to_currency(tranction.credit_amount, unit: '₹')
      end
      row :tranction_date
    end
  end
end
