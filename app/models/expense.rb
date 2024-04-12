class Expense < ApplicationRecord
  validates :date , :description, :amount, presence: true
  belongs_to :employee 
  belongs_to :expense_report, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  enum status: {
      Pending: 'Pending',
      Approved: 'Approved',
      Rejected: 'Rejected',
      partically_approved: 'partically_approved'
  }
  before_validation :set_default_status, on: :create
  # validates :approval_status, inclusion: { in: approval_statuses.keys, message: "is not a valid approval status" }
  def set_default_status
    self.status ||= :Pending
  end
  # validates :approval_status, inclusion: { in: approval_statuses.keys, message: "is not a valid approval status" }
  after_commit :update_expense_report_status, on: [:create, :update]

  private

  def update_expense_report_status

    expense_report = self.expense_report

    # If the expense does not have an associated expense report, return early
    return unless expense_report

    # Get the statuses of all expenses belonging to the same expense report
    statuses = expense_report.expenses.pluck(:status)

    # If at least one expense is approved, set expense report status to partially_approved
    if statuses.all? { |status| status == 'Pending' }
      expense_report.update(status: 'pending')
    end

    if statuses.include?('Approved')
      expense_report.update(status: 'partially_approved')
    end

    # If all expenses are approved, set expense report status to approved
    if statuses.all? { |status| status == 'Approved' }
      expense_report.update(status: 'approved')
    end

    # If all expenses are rejected, set expense report status to rejected
    if statuses.all? { |status| status == 'Rejected' }
      expense_report.update(status: 'rejected')
    end
  end
end
