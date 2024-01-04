# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end
    columns do
      column do
        panel 'Types' do 
          table_for Type.all.order(:id) do
            column :id
            column  :name
            column  'Available Quantity', :quantity
            column  'Damage Quantity', :damage

          end
        end

        panel 'Supplier Balances' do
          total_balance = 0 
          table_for Supplier.all.order(:id).includes(:supplier_tranctions) do
            column :id
            column  :name
            column  'Balance Amount' do |supplier|
              balance = supplier.balance
              total_balance += balance
              number_to_currency(balance, unit: '₹')
            end
          end
          columns class: 'float_right bold' do
            column do
              span number_to_currency(total_balance, unit: '₹')
            end
            column do
              span 'Total Balance'
            end
          end
        end

        panel 'Shopkeeper Balances' do
          total_balance = 0
          table_for Shopkeeper.all.order(:id).includes(:shopkeeper_tranctions) do
            column :id
            column  :name
            column  'Balance Amount' do |shopkeeper|
              balance = shopkeeper.balance
              total_balance += balance
              number_to_currency(balance, unit: '₹')
            end
          end
          columns class: 'float_right bold' do
            column do
              span number_to_currency(total_balance, unit: '₹')
            end
            column do
              span 'Total Balance'
            end
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
