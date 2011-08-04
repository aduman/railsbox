class Log < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :controller, :action, :ip_address, :user_agent
   validates_format_of :ip_address, :with => /^(\d{1,3}\.){3}\d{1,3}$/
  
end
