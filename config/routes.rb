Rails.application.routes.draw do
  resources :employees do
    # get 'employee_expense_reports', on: :collection
    resources :expenses do
      resources :comments
    end
    resources :expense_reports do
      resources :expenses do
        resources :comments
      end
        # member do
        #   patch :approve
        #   patch :reject
        # end
      
    end
    # get 'employee_expense_reports', on: :collection
    get 'employee_expense_reports', to: 'employees#employee_expense_reports'
    get 'submit_for_approval', to: 'employees#submit_for_approval'
    get 'manual_check', to: 'employees#manual_check'
  end
end
