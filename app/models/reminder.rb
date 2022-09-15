class Reminder < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :color, presence: true
  validates :scheduled_datetime, presence: true
end
