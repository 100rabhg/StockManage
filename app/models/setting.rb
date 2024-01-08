class Setting < ApplicationRecord
  # shopkeeper_dues_auto_reminder -> boolean , default: :false
  # reminder_send_time -> integer
  # again_reminder_send_time -> integer

  enum reminder_send_time: ['2 week', '3 week', '1 month', '2 month'], _suffix: true
  enum again_reminder_send_time: ['1 day', '2 day', '1 week', '1 month'], _suffix: true

  after_update :on_auto_reminder_notification

  def on_auto_reminder_notification
    if shopkeeper_dues_auto_reminder
      ShopkeeperPaymentNotificationJob.perform_later(true)
    end
  end

  validate :validate_setting

  def validate_setting
    errors.add(:setting, "can't create new setting update existing one") if Setting.count > 0 && self.new_record?
  end

  def reminder_send_time_in_duration
    to_duration(reminder_send_time)
  end

  def again_reminder_send_time_in_duration
    to_duration(again_reminder_send_time)
  end

  def to_duration(duration_in_string)
    case duration_in_string
    when '1 day'
      ActiveSupport::Duration.new(0, days:1)
    when '2 day'
      ActiveSupport::Duration.new(0, days:2)
    when '1 week'
      ActiveSupport::Duration.new(0, weeks:1)
    when '2 week'
      ActiveSupport::Duration.new(0, weeks:2)
    when '3 week'
      ActiveSupport::Duration.new(0, weeks:3)
    when '1 month'
      ActiveSupport::Duration.new(0, months:1)
    when '2 month'
      ActiveSupport::Duration.new(0, months:2)
    end
  end
end
