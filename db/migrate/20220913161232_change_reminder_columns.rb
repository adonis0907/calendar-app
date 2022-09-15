class ChangeReminderColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :reminders, :scheduled_date, :datetime
    rename_column :reminders, :scheduled_date, :scheduled_datetime
    remove_column :reminders, :scheduled_time
  end
end
