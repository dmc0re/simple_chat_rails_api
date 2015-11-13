class Channel < ActiveRecord::Base
  has_many :messages, dependent: :destroy

  belongs_to :user

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :user_id, numericality: { only_integer: true }
end
