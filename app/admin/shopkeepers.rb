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
    column :dues_reminder_send_at
    column :updated_at
    actions
  end
  
  form do |f|
    f.semantic_errors
    f.inputs 'Shopkeeper Details' do
      f.input :name
      f.input :address
      f.input :phone_number, label: 'Phone Number(with country code)'
      f.input :comment
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :address
      row :phone_number
      row :dues_reminder_send_at
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

  action_item :send_due_reminder, only: :show do
    if shopkeeper.balance > 0
      link_to 'Send Due Reminder', dues_reminder_admin_shopkeeper_path, method: :put
    end
  end

  action_item :send_due_reminder_all, only: :index do
    link_to 'Send Due Reminder all Shopkeeper', dues_reminder_all_admin_shopkeepers_path, method: :put
  end
  
  member_action :download_invoice, method: :get do
    pdf_service = PdfGeneratorService.new
    pdf_content = pdf_service.generate_pdf(resource)
    pdf_filename = "#{resource.name}_invoice_#{Date.today.strftime('%d_%b_%y')}.pdf"

    respond_to do |format|
      format.pdf do
        send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  member_action :dues_reminder, method: :put do
    ShopkeeperSmsJob.perform_now(resource)
    redirect_to admin_shopkeeper_path, notice: "Send Reminder notification soon"

  end

  collection_action :dues_reminder_all, method: :put do
    ShopkeeperPaymentNotificationJob.perform_now()
    redirect_to collection_path, notice: "Send Reminder notification soon"
  end
end
