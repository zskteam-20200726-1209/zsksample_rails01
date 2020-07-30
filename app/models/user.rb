class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email,
    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)* \z/ }
end
