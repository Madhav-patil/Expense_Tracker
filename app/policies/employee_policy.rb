class EmployeePolicy < ApplicationPolicy

  def employee_expense_reports?
    user.admin?
  end
  def manual_check?
    user.admin?
  end
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
