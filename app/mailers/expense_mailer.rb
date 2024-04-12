# app/mailers/expense_mailer.rb
class ExpenseMailer < ApplicationMailer
    def expense_approval_notification(employee, expense)
      @employee = employee
      @expense = expense
      mail(to: @employee.email, subject: 'Expense Approved')
    end
  
    def expense_rejection_notification(employee, expense)
      @employee = employee
      @expense = expense
      mail(to: @employee.email, subject: 'Expense Rejected')
    end

    def expense_partial_notification(employee, expense)
      @employee = employee
      @expense = expense
      mail(to: @employee.email, subject: 'Expense Partially Approved')
    end
  end
  