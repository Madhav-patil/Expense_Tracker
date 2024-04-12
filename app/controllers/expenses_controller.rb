require 'net/http'
require 'json'
class ExpensesController < ApplicationController
  # include Pundit
  # skip_before_action :verify_authenticity_token
  
  before_action :set_employee
  before_action :set_expense_report
  before_action :set_expense, only: [:show, :update, :destroy]
 

  # GET /employees/:employee_id/expense_reports/:expense_report_id/expenses
  # GET /employees/:employee_id/expenses
  def index
    if @expense_report
      @expenses = @expense_report.expenses
    else
      @expenses = @employee.expenses
    end
    render json: @expenses
  end

  # GET /employees/:employee_id/expense_reports/:expense_report_id/expenses/:id
  def show
    # if @expense_report
    #   @expense = @expense_report.expense
    # else
    #   @expense = @employee.expense
    # end
    render json: @expense
  end
  # byebug
  def create
    if @employee.employment_status == 'active'
      if @expense_report
          @expense = @expense_report.expenses.new(expense_params.merge!(employee_id: @employee.id))
      elsif params[:expense_report_id].present?
          render json: { error: 'Invalid expense_report_id' }, status: :unprocessable_entity
        return
      else
          @expense =  @employee.expenses.new(expense_params.merge!(employee_id: @employee.id))
      end

      if @expense.save
        render json: @expense
      else
        render json: @expense.errors
      end
    else
      render json: { error: 'Employee is terminated/separated and cannot apply for reimbursement' }, status: :unprocessable_entity
    end
  end

  # POST /employees/:employee_id/expense_reports/:expense_report_id/expenses
  # def create
  #   @expense = @expense_report.expenses.new(expense_params)
  #   @expense.employee_id = @employee.id
  #   api_key = 'b490bb80'
  #   url = 'https://my.api.mockaroo.com/invoices.json'

  #   uri = URI(url)
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true

  #   request = Net::HTTP::Post.new(uri.path)
  #   request['X-API-Key'] = api_key
  #   request.body = { 'invoice_id': @expense.invoice_id }.to_json

  #   response = http.request(request)

  # if response.code == '200'
  #     validation_result = JSON.parse(response.body)
  #     #puts "#{validation_result}"
  #     json_response = JSON.parse(response.body)

  #   if json_response["status"] == true
  #     if @expense.save
  #       render json: @expense, status: :created, location: [@employee, @expense_report, @expense]
  #     else
  #       render json: @expense.errors, status: :unprocessable_entity
  #     end
  #   else
  #     render json: {message: "Invalid Invoice Number"}, status: :unprocessable_entity
  #   end
  # else
  #   render json: { message: 'Invoice validation failed' }, status: :unprocessable_entity
  #   end
  # end


  # PATCH/PUT /employees/:employee_id/expense_reports/:expense_report_id/expenses/:id
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/:employee_id/expense_reports/:expense_report_id/expenses/:id
  def destroy
    @expense.destroy
  end

  # def approve
  #   @expense = Expense.find(params[:id])
  #   authorize @expense, :approve?, policy_class: ExpensePolicy.new(@expense.employee, params[:admin])
  #   if params[:admin] == 'true'
  #     @expense.update(approved: true)
  #     ExpenseMailer.expense_approval_notification(@expense.employee, @expense).deliver_now
  #     render json: @expense
  #   else
  #     # Render a message indicating that the employee is not authorized
  #     render json: { error: 'You are not authorized to approve expenses' }, status: :unauthorized
  #   end

  # end
  
  # def reject
  #   @expense = Expense.find(params[:id])
  #   authorize @expense, :approve?, policy_class: ExpensePolicy.new(@expense.employee, params[:admin])
  #   if params[:admin] == 'true'
  #     @expense.update(approved: false)
  #     ExpenseMailer.expense_rejection_notification(@expense.employee, @expense).deliver_now
  #     render json: @expense
  #   else
  #     # Render a message indicating that the employee is not authorized
  #     render json: { error: 'You are not authorized to approve expenses' }, status: :unauthorized
  #   end

  # end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find_by!(id: params[:employee_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Employee not found" }, status: :not_found

    end

    def set_expense_report
      @expense_report = @employee.expense_reports.find_by(id: params[:expense_report_id])
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "ExpenseReport not found" }, status: :not_found

    end

    def set_expense
      if @expense_report
        begin
        @expense = @expense_report.expenses.find_by!(id: params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Expense not found" }, status: :not_found 
        end  
      else
        begin
        @expense = @employee.expenses.find_by!(id: params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Expense not found" }, status: :not_found 
        end
      end
      # @expense = @expense_report.expenses.find(params[:id])
    end
    # def set_current_user
    #   current_user = Employee.find(params[:employee_id]) if params[:employee_id].present?
    # end


    # Only allow a trusted parameter "white list" through.
    def expense_params
      params.require(:expense).permit(:date, :description, :amount, :invoice_id)
    end

end
