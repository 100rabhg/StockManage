class ShopkeeperPaymentNotificationJob < ApplicationJob

  def perform(auto = false)
    Shopkeeper.find_each do |shopkeeper|
      next unless shopkeeper.sell_orders.present? && shopkeeper.balance > 0
      if auto
        next unless shopkeeper.last_payment_older_than_or_no_payment?(Setting.first&.reminder_send_time_in_duration || 1.month)
        unless shopkeeper.dues_reminder_send_at.nil?
          next unless shopkeeper.dues_reminder_send_at <= DateTime.now - (Setting.first&.again_reminder_send_time_in_duration || 1.week)
        end
      end

      send_reminder_notification_to_shopkeeper(shopkeeper)

    end
    # next day check again
    ShopkeeperPaymentNotificationJob.set(wait: 1.day).perform_later(true) if Setting.first.shopkeeper_dues_auto_reminder && auto
  end

  def send_reminder_notification_to_shopkeeper(shopkeeper)
    ShopkeeperSmsJob.perform_later(shopkeeper)
  end
end
