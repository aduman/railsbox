class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  before_filter :is_authorised
  
  after_filter :log, :except=>[:new, :edit]
  

  layout proc{ |c| c.request.xhr? ? false : "application" }
  
  

def log
  if !defined? @log_controller
    @log_controller = self.controller_name.singularize
  end
  
  if !defined? @log_action
    @log_action = self.action_name
  end
  
  if !defined? @log_parameters
    @log_parameters = ActionController::Base.helpers.sanitize(params.except(:controller,:action,:authenticity_token,:password,:utf8).to_param())
  end
  
  #For logout
  if !defined? @log_user_id
    @log_user_id = current_user
  end
  
  @log = Log.new({
    "user_id" =>  @log_user_id, 
    "controller" =>  @log_controller, 
    "action" =>  @log_action, 
    "parameters" =>  @log_parameters, 
    "ip_address" =>  request.remote_ip,
    "user_agent" =>  request.env['HTTP_USER_AGENT'], 
    "file_path" => @log_file_path,
    "target_id" => @log_target_id
    })
  @log.save
end

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

def check_hotlink
  is_authorised
  redirect_to root_path and return unless current_user.can_hotlink
end

end
