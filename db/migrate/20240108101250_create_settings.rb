class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.boolean :shopkeeper_dues_auto_reminder, default: :false
      t.integer :reminder_send_time
      t.integer :again_reminder_send_time
      t.timestamps
    end
  end
end
