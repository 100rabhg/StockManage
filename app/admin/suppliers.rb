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
          tranction.buy_order ? tranction.buy_order.total_price : '-'
        end
        column 'Credit Buy Order' do |tranction|
          tranction.buy_order
        end
        column :debit_amount
        column :tranction_date
      end
      columns class: 'float_right bold' do
        column do
          balance = 0
          supplier.supplier_tranctions.each do |tranction|
            if tranction.buy_order.present?
                balance += tranction.buy_order.total_price
            else
              balance -= tranction.debit_amount
            end
          end
          span "\u20B9#{balance}"
        end
        column do
          span 'Balance'
        end
      end
    end
  end
end
