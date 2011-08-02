class UserGroupController < ApplicationController
  after_filter :logFilePath, :except=>[:new]
  def new
    @userGroup = UserGroup.new
    @users = User.all
  end

  def create
    @userGroup = UserGroup.new(params[:user_group])
    @userGroup.group_id = params[:group_id]
    if @userGroup.save
      redirect_to group_path(@userGroup.group_id), :notice => "User Added"
    else
      @users = User.all
      redirect_to group_path(@userGroup.group), :notice => "User already a member of this group"
    end
  end
  
  def destroy
    @userGroup = UserGroup.find(params[:group_id])
    @userGroup.destroy
    redirect_to group_path(@userGroup.group), :notice => "Successfully removed user from group"
  end
  
  private
  
  def logFilePath
    @log_file_path = "Group: " + @userGroup.group.name + ", User: " + @userGroup.user.name
    @log_target_id = @userGroup.id
  end
end