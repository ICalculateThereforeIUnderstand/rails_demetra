class ApplicationController < ActionController::Base
    
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery unless: -> { request.format.json? }
    #protect_from_forgery with: :null_session

    

    helper_method :retrieve_last_index_page_or_default

    def store_last_index_page
        session[:last_index_page] = request.fullpath
    end
    
    def retrieve_last_index_page_or_default(default_path: root_path)
        session[:last_index_page] || default_path
    end

    protected

      def configure_permitted_parameters
        added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
        added_attrs1 = [:login, :password, :remember_me]
        devise_parameter_sanitizer.permit(:sign_up,
          keys: added_attrs)
        devise_parameter_sanitizer.permit(:account_update,
          keys: added_attrs)
      end

    private

      # definiramo redirect nakon signin-a
      def after_sign_in_path_for(resource_or_scope)
        "/manager1"
      end
end
