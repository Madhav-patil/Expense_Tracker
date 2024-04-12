class ApplicationController < ActionController::API
    include Pundit

    def current_user
        user = Employee.find(params[:employee_id])
    end
    
end
