class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  validates :name, presence: true, uniqueness: true

  before_create :generate_authentication_token!

  has_many :channels
  has_many :message

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.where(auth_token: auth_token).exists?
  end

end
