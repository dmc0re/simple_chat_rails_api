class Channel < ActiveRecord::Base
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
end
