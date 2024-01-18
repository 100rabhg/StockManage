ActiveAdmin.register AdminUser do
  permit_params :email, :admin_user_type, :profile_photo

  index do
    selectable_column
    id_column
    column :email
    column :admin_user_type
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :sign_in_count
      row :admin_user_type
      row :last_sign_in_ip
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :admin_user_type
      f.input :profile_photo, as: :file, input_html: {accept: "image/*"}
      render('shared/profile_photo', f: f)
    end
    f.actions
  end

end
