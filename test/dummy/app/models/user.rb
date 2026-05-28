class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :password_complexity


  def password_complexity
    return if password.blank?

    has_uppercase = password =~ /[A-Z]/
    has_lowercase = password =~ /[a-z]/
    has_number = password =~ /[0-9]/
    has_special_char = password =~ /[^A-z0-9]/
    is_right_length = Devise.password_length.include?(password.length)

    return if has_uppercase &&
              has_lowercase &&
              has_number &&
              has_special_char &&
              is_right_length
    
    errors.add :password, ' is not strong enough'
  end

end
