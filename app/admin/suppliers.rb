ActiveAdmin.register Supplier do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :address, :comment, :phone_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :comment, :phone_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  menu parent: 'Supplier', priority: 1

  index do
    selectable_column
    id_column
    column :name
    column :address
    column :phone_number
    column 'Balance' do |supplier|
      number_to_currency(supplier.balance, unit: '₹')
    end
    column :comment
    column :updated_at
    actions
  end
  
  show do
    attributes_table do
      row :name
      row :address
      row :phone_number
      row :comment
      row :created_at
      row :updated_at
    end

    panel 'Tranctions' do
      table_for supplier.supplier_tranctions do
        column 'Credit Amount' do |tranction|
          number_to_currency(tranction.buy_order&.total_price, unit: '₹')
        end
        column 'Credit Buy Order' do |tranction|
          tranction.buy_order
        end
        column :debit_amount do |tranction|
          number_to_currency(tranction.debit_amount, unit: '₹')
        end
        column :tranction_date
      end
      columns class: 'float_right bold' do
        column do
          span number_to_currency(supplier.balance, unit: '₹')
        end
        column do
          span 'Balance'
        end
      end
    end
  end

  action_item :pay, only: :show do
    link_to 'Pay', "/admin/supplier_tranctions/new?id=#{supplier.id}"
  end
end
