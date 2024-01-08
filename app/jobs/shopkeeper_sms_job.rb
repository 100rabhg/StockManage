class ShopkeeperSmsJob < ApplicationJob
  queue_as :default

  def perform(shopkeeper)
    return unless shopkeeper.sell_orders.present? && shopkeeper.balance > 0

    client = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
    
    shopkeeper.update(dues_reminder_send_at: Time.now)

    message = client.messages.create(
      from: ENV['twilio_phone_number'],
      to: shopkeeper.phone_number,
      body: "Dear #{shopkeeper.name},\n
      Just a quick reminder that your payment of #{ActionController::Base.helpers.number_to_currency(shopkeeper.balance, unit: '₹')} is due. Please make a payment to clear your dues. Thank you!\n
      \n
      Best,\n
      [Your Company Name]",
    )
  end
end
