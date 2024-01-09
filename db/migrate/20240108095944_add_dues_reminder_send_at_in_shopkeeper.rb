class AddDuesReminderSendAtInShopkeeper < ActiveRecord::Migration[7.0]
  def change
    add_column :shopkeepers, :dues_reminder_send_at, :datetime
  end
end
