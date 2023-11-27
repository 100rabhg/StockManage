ActiveAdmin.register OtherExpense do
  permit_params :name, :price, :buy_order_id

  form do |f|
    f.inputs 'Other Expense Details' do
      f.input :buy_order, as: :select, collection: BuyOrder.all.map { |buy_order| [buy_order.id, buy_order.id] }
      f.input :name
      f.input :price
    end
    f.actions
  end
end





















