class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable, :trackable

  enum admin_user_type: ['super admin', 'admin', 'manager']

  validates :admin_user_type, presence: true

  has_one_attached :profile_photo
end
