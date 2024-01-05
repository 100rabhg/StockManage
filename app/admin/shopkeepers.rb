ActiveAdmin.register Shopkeeper do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :address, :phone_number, :comment
  menu parent: 'Shopkeeper', priority: 1
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :phone_number, :comment]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :name
    column :address
    column :phone_number
    column 'Balance' do |shopkeeper|
      number_to_currency(shopkeeper.balance, unit: '₹')
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
      table_for shopkeeper.shopkeeper_tranctions do
        column 'Debit Amount' do |tranction|
          number_to_currency(tranction.sell_order&.total_price, unit: '₹')
        end
        column 'Debit Sell Order' do |tranction|
          tranction.sell_order
        end
        column :credit_amount do |tranction|
          number_to_currency(tranction.credit_amount, unit: '₹')
        end
        column :tranction_date
      end
      columns class: 'float_right bold' do
        column do
          span number_to_currency(shopkeeper.balance, unit: '₹')
        end
        column do
          span 'Balance'
        end
      end
    end
  end
  action_item :pay, only: :show do
    unless shopkeeper.sell_orders.count.zero?
      link_to 'Download Invoice', download_invoice_admin_shopkeeper_path(shopkeeper, format: :pdf)
    end
  end
  action_item :pay, only: :show do
    unless shopkeeper.sell_orders.count.zero?
      link_to 'Get Payed', "/admin/shopkeeper_tranctions/new?id=#{shopkeeper.id}"
    end
  end
  
  member_action :download_invoice, method: :get do
    shopkeeper = Shopkeeper.find(params[:id])
    pdf_service = PdfGeneratorService.new
    pdf_content = pdf_service.generate_pdf(shopkeeper)
    pdf_filename = "#{shopkeeper.name}_invoice_#{Date.today.strftime('%d_%b_%y')}.pdf"

    respond_to do |format|
      format.pdf do
        send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end
end
