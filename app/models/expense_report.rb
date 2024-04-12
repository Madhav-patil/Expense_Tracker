class ExpenseReport < ApplicationRecord
  validates :name, :description, :start_date, :end_date, presence: true
  belongs_to :employee
  has_many :expenses , dependent: :destroy 
  has_many :comments, as: :commentable, dependent: :destroy
  enum status: 
    { pending: 'pending',
      approved: 'approved', 
      rejected: 'rejected', 
      partially_approved: 'partially_approved'
    }
end
