class EmployeesController < ApplicationController 
  #skip_before_action :verify_authenticity_token  
  before_action :set_employee, only: [:show, :update, :destroy]
  
    # GET /employees
    def index
      @employees = Employee.all
      render json: @employees, include: { expenses: { only: [:status , :validation_message] } }
    end
    
  
    # GET /employees/1
    def show
      render json: @employee
    end
  
    # POST /employees
    def create
      # if valid_employment_status?(params[:employment_status])
       
      # else
      #   render json: { error: "Not a valid employment status" }, status: :unprocessable_entity
      # end
      begin
      @employee = Employee.create!(employee_params)
      rescue ::ArgumentError 
        render json: { message: "#{params[:employment_status]} is Not Valid Status. Only active, terminated and separated are valid" }, status: :bad_request
        return
      end
        render json: @employee, status: :created, location: @employee
      
    end
  
    # PATCH/PUT /employees/1
    def update
      if @employee.update(employee_params)
        render json: @employee
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /employees/1
    def destroy
      @employee.destroy
      head :no_content
    end
    def employee_expense_reports
      url_employee_id = params[:employee_id]
      request_body_employee_id = params[:user_id]

      # Check if the employee is an admin based on the URL parameter employee_id
      @employee = Employee.find(url_employee_id)
      begin
        authorize @employee 
      rescue Pundit::NotAuthorizedError
        render json: { error: 'You are not authorized to search' }, status: :unauthorized
        return
      end
      # Use the employee_id from the request body to fetch expense details
      employee_id = request_body_employee_id
      begin
      @employee = Employee.find_by!(id: employee_id)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "employee not found" }, status: :not_found 
        return
      end
      @employee_expense_reports = Employee.find(employee_id).expense_reports

      render json: { employee: @employee.name,  expense_reports: @employee_expense_reports }
    end
    def submit_for_approval
      expense_employee_id = params[:employee_id]
      @employee = Employee.find(expense_employee_id)
      @expense_report = @employee.expense_reports.find_by(id: params[:expense_report_id])
      begin
        @expense_report = @employee.expense_reports.find_by!(id: params[:expense_report_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "employee not found" }, status: :not_found 
          return
      end
      @expense = @employee.expenses.find_by(id: params[:expense_id])
      if @expense_report
        # If expense_report_id is provided, validate all expenses under the expense report
        @expenses = @expense_report.expenses
      else
        # If expense_id is provided, validate only that expense
        @expenses = [@expense]
      end
  
      # Validate each expense
      @expenses.each do |expense|
        api_key = 'b490bb80'
        url = 'https://my.api.mockaroo.com/invoices.json'
  
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
  
        request = Net::HTTP::Post.new(uri.path)
        request['X-API-Key'] = api_key
        request.body = { 'invoice_id': expense.invoice_id }.to_json
  
        response = http.request(request)
  
      if response.code == '200'
          validation_result = JSON.parse(response.body)
          #puts "#{validation_result}"
          json_response = JSON.parse(response.body)
  
        if json_response["status"] == true
          expense.update(validation_message: 'System approved')
        else
          expense.update(validation_message: 'Invalid invoice')
        end
      end
    end  
  
      render json: { message: 'Expenses submitted for approval' }
    end

    def manual_check
      @employee = Employee.find(params[:employee_id])
      begin
        authorize @employee 
      rescue Pundit::NotAuthorizedError
        render json: { error: 'You are not authorized to Manual Check' }, status: :unauthorized
        return
      end
      # expense_employee_id = params[:user_id]
      # @employee = Employee.find(expense_employee_id)
      # unless @employee
      #   render json: { error: "Employee with ID #{params[:id]} not found" }, status: :not_found
      #   return
      # end
      begin
        @employee = Employee.find_by!(id: params[:user_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "employee not found" }, status: :not_found 
          return
      end
      @expense_report = @employee.expense_reports.find_by(id: params[:expense_report_id])

      # @expense = @employee.expenses.find_by(id: params[:expense_id])

      if @expense_report
        # If expense_report_id is provided, update all expenses under the expense report
        begin
          @expense = @expense_report.expenses.find_by!(id: params[:expense_id])
          rescue ActiveRecord::RecordNotFound
            render json: { error: "expense not found" }, status: :not_found 
            return
        end
      else
        # If expense_id is provided, update only that expense
        begin
          @expense = @employee.expenses.find_by!(id: params[:expense_id])
          rescue ActiveRecord::RecordNotFound
            render json: { error: "expense not found" }, status: :not_found 
            return
        end
      end
  
      # Update approved status and approved amount for each expense
      # @expenses.each do |expense|
      #   # Update approved status and approved amount based on the request parameters
      #   expense.update(
      #     approval_status: params[:approval_status],
      #     reimbursement_amount: params[:approved_amount]
      #   )
      #   if expense.approval_status == 'Approved'
      #     ExpenseMailer.expense_approval_notification(@expense.employee, @expense).deliver_now
      #   elsif expense.approval_status == 'partically_approved'  
      #     ExpenseMailer.expense_partial_notification(@expense.employee, @expense).deliver_now
      #   else
      #     ExpenseMailer.expense_rejection_notification(@expense.employee, @expense).deliver_now
      #   end  
      # end
      @expense.update(
          status: params[:approval_status],
          reimbursement_amount: params[:approved_amount]
        )
        if @expense.status == 'Approved'
          ExpenseMailer.expense_approval_notification(@expense.employee, @expense).deliver_now
        elsif @expense.status == 'partically_approved'  
          ExpenseMailer.expense_partial_notification(@expense.employee, @expense).deliver_now
        else
          ExpenseMailer.expense_rejection_notification(@expense.employee, @expense).deliver_now
        end  
      render json: { message: 'Expenses manually checked' }
    end

  # api_key = 'b490bb80'
  #     url = 'https://my.api.mockaroo.com/invoices.json'

  #     uri = URI(url)
  #     http = Net::HTTP.new(uri.host, uri.port)
  #     http.use_ssl = true

  #     request = Net::HTTP::Post.new(uri.path)
  #     request['X-API-Key'] = api_key
  #     request.body = { 'invoice_id': @expense.invoice_id }.to_json

  #     response = http.request(request)

  #   if response.code == '200'
  #       validation_result = JSON.parse(response.body)
  #       #puts "#{validation_result}"
  #       json_response = JSON.parse(response.body)

  #     if json_response["status"] == true
  

    # def
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_employee
          @employee = Employee.find_by(id: params[:id])
          unless @employee
            render json: { error: "Employee with ID #{params[:id]} not found" }, status: :not_found
            return
          end
      end
  
      # Only allow a trusted parameter "white list" through.
      def employee_params
        params.require(:employee).permit(:name, :department, :employment_status, :email)
      end
  end
  