class User < ApplicationRecord
  before_save {email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 

  validates :name, presence: true,
    length: {maximum: Settings.user_model.max_length_name} 
  validates :email, presence: true,
    length: {maximum: Settings.user_model.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.user_model.min_length_password}
end
