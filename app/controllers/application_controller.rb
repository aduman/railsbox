class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  before_filter :is_authorised


private

def is_authorised
  redirect_to log_in_path and return unless current_user
  redirect_to log_in_path and return unless current_user.active
end  


def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end


def check_admin
  is_authorised
  redirect_to root_path and return unless current_user.is_admin
end  

end
