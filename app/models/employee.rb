class Employee < ApplicationRecord
    validates :name, :department, :employment_status, presence: true
    has_many :expenses , dependent: :destroy 
    has_many :expense_reports, dependent: :destroy
    has_many :comments, dependent: :destroy
   validate :employment_status
    enum employment_status: {
    active: 'active',
    terminated: 'terminated',
    separated: 'separated'
  }
  private

  def valid_employment_status
    unless employment_status.present? && employment_statuses.keys.include?(employment_status)
      errors.add(:employment_status, "is not a valid employment status")
    end
  end
end
  