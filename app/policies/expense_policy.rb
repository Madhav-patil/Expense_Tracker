class ExpensePolicy < ApplicationPolicy
  # attr_reader :employee, :admin_param

  # def initialize(employee, admin_param)
  #   @employee = employee
  #   @admin_param = admin_param
  # end

  # def approve?
  #   puts "Inside Approve"
  #   employee.admin? || admin_param == 'true'
  # end

  # def reject?
  #   employee.admin? || admin_param == 'true'
  # end

  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
    
  #   # def resolve
  #   #   scope.all
  #   # end
  #   # def initialize(employee, admin_param)
  #   #   @employee = employee
  #   #   @admin_param = admin_param
  #   # end
  # end
end
