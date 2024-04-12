class CommentsController < ApplicationController
    # skip_before_action :verify_authenticity_token 
    before_action :set_commentable
    before_action :set_employee
  def create
    unless @employee && (@employee.admin? || @commentable.employee_id == @employee.id)
        render json: { error: 'Unauthorized' }, status: :unauthorized
        return
    end
    @comment = @commentable.comments.new(comment_params)
    @comment.employee_id = @employee.id
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end
  def index
    @comments = @commentable.comments
    render json: @comments
  end
  def show
    render json: @comment
  end

  private

  def set_commentable
    if params[:expense_id]
      
      begin
        @commentable = Expense.find_by!(id: params[:expense_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "expense not found" }, status: :not_found 
          return
      end
    elsif params[:expense_report_id]
      @commentable = ExpenseReport.find(params[:expense_report_id])
    else
        render json: { error: 'Invalid commentable resource' }, status: :unprocessable_entity
    end
  end
  def set_employee
    @employee = Employee.find_by!(id: params[:employee_id])
    # puts "{#@employee}"
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Employee not found" }, status: :not_found

  end
  def comment_params
    params.require(:comment).permit(:content)
  end
end
