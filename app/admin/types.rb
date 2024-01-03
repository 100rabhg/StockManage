ActiveAdmin.register Type do

  permit_params :name, :capacity, :comment, :quantity, :damage

  form do |f|
    f.inputs 'Type Details' do
      f.input :name
      f.input :capacity
      f.input :comment
      f.input :damage
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :name 
    column :capacity 
    column :comment 
    column  'Available quantity', :quantity 
    column 'Damage Quantity', :damage
    actions
  end

  show do 
    attributes_table do
      row :name
      row :capacity 
      row :comment 
      row :quantity 
      row :damage
    end
  end
  
end
