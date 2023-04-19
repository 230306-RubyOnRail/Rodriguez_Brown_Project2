class User < ApplicationRecord
  has_secure_password
  has_many :reimbursements
  validates :username, presence: true, length: { in: 4..16 }, uniqueness: true
  validates :password, presence: true, length: { in: 8..20 }
end
