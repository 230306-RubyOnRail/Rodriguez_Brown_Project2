class Reimbursement < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
  validates :status, presence: true, numericality: { in: 1..3 }
  validates :amount, presence: true, numericality: { in: 0..100000 }
end
