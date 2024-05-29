class User < ApplicationRecord
    # Including the devise JWT revocation strategy
    include Devise::JWT::RevocationStrategies::JTIMatcher
  
    # Relationship
    has_one :employee, dependent: :destroy
  
    # Devise modules for user authentication
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, :jwt_authenticatable,
           jwt_revocation_strategy: self
  
    # Private methods section
  
  end