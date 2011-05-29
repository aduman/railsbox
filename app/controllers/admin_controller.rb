class AdminController < ApplicationController
  
  before_filter :check_admin
  
  def panel
    @users = User.where(:active=>true).limit(5)
    @non_users = User.where(:active=>false)
    @groups = Group.limit(5)
  end


  def search_users
  end

  def search_groups
  end

end
