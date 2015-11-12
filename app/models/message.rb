class Message < ActiveRecord::Base
  belongs_to :channel

  validates :text, presence: true, length: { maximum: 255 }
  validates :channel_id, numericality: { only_integer: true }
end
