class CreateReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :description
      t.string :color
      t.date :scheduled_date
      t.time :scheduled_time

      t.timestamps
    end
  end
end
