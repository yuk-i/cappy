class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

         
  belongs_to :user_icon
  belongs_to :family
  
  has_many :hospital_posts
  has_many :target_daily_records
  
  validates :nickname, presence: true
  # validates :user_icon_id, presence: true
  
  
end
