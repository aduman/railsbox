class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  before_filter :is_authorised
  
  after_filter :log, :except=>[:new, :edit]
  

  layout proc{ |c| c.request.xhr? ? false : "application" }
  
  

def log
  log_controller = @log_controller || self.controller_name.singularize 
	log_action = @log_action || self.action_name
	log_parameters = @log_parameters || ActionController::Base.helpers.sanitize(params.except(:controller,:action,:authenticity_token,:password,:utf8).to_param())
	log_user_id = current_user.id if current_user && !@log_user_id 
	log = Log.new({
  	:user_id =>  @log_user_id, 
  	:controller =>  log_controller, 
  	:action =>  log_action, 
  	:parameters =>  log_parameters, 
  	:ip_address =>  request.remote_ip,
  	:user_agent =>  request.env['HTTP_USER_AGENT'], 
  	:file_path => @log_file_path,
  	:target_id => @log_target_id
  })
	log.save
end

def is_authorised
  redirect_to log_in_path and return unless current_user and current_user.active 
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

def build_date_from_params(field_name, params)
  Date.new(params["#{field_name.to_s}(1i)"].to_i,
  params["#{field_name.to_s}(2i)"].to_i,
  params["#{field_name.to_s}(3i)"].to_i)
end

end
