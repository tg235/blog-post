class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  has_many :blog_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :username, presence: true, uniqueness: true
end
