class Application < ApplicationRecord
    has_secure_token :token
    has_many :chats, dependent: :destroy
  
    validates :name, presence: true # TODO: is name should be unique
  end
  