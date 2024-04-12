class ExpenseReportsController < ApplicationController
    # skip_before_action :verify_authenticity_token
    before_action :set_employee
    before_action :set_expense_report, only: [:show, :update, :destroy]
  
    # GET /employees/:employee_id/expense_reports
    def index
      @expense_reports = @employee.expense_reports
      render json: @expense_reports, include: { expenses: { only: [:status , :validation_message] } }
    end
  
    # GET /employees/:employee_id/expense_reports/:id
    def show
      render json: @expense_report, include: { expenses: { only: [:status, :validation_message] } }
    end
  
    # POST /employees/:employee_id/expense_reports
    def create
        if @employee.employment_status == 'active' 
            @expense_report = @employee.expense_reports.new(expense_report_params)
        
            if @expense_report.save
                render json: @expense_report, status: :created
            else
                render json: @expense_report.errors, status: :unprocessable_entity
            end
        else
            render json: { error: 'Employee is terminated/separated and cannot apply for reimbursement' }, status: :unprocessable_entity
        end
    end
  
    # PATCH/PUT /employees/:employee_id/expense_reports/:id
    def update
      if @expense_report.update(expense_report_params)
        render json: @expense_report
      else
        render json: @expense_report.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /employees/:employee_id/expense_reports/:id
    def destroy
      @expense_report.destroy
      head :no_content
    end
  
    private
      def set_employee
        # @employee = Employee.find(params[:employee_id])
        @employee = Employee.find_by!(id: params[:employee_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Employee not found" }, status: :not_found
      end
  
      def set_expense_report
        @expense_report = @employee.expense_reports.find_by!(id: params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "ExpenseReport not found" }, status: :not_found
      end
  
      def expense_report_params
        params.require(:expense_report).permit(:name, :description, :start_date, :end_date)
      end
  end
  