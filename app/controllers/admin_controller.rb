class AdminController < ApplicationController
  
  before_filter :check_admin
  
  def panel
  end

end
