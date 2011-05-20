class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  before_filter :logged_in


private

def logged_in
  redirect_to root_path unless current_user
end  


def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end

end
