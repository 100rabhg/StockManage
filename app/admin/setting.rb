ActiveAdmin.register Setting do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  #
  # or
  #
  # permit_params do
  #   permitted = [:shopkeeper_dues_auto_reminder, :reminder_send_time, :again_reminder_send_time]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  menu false

  permit_params :shopkeeper_dues_auto_reminder, :reminder_send_time, :again_reminder_send_time
  actions :index, :edit, :show, :update

  show do
    attributes_table do
      row :shopkeeper_dues_auto_reminder
      row :reminder_send_time
      row :again_reminder_send_time
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Setting Details' do
      f.input :shopkeeper_dues_auto_reminder
      f.input :reminder_send_time
      f.input :again_reminder_send_time
    end
    f.actions do
      f.submit
      f.cancel_link(admin_setting_path(f.object))
    end
  end
end
