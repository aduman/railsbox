class UserGroupController < ApplicationController
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
      render "new"
    end
  end
  
  def destroy
    @userGroup = UserGroup.find(params[:group_id])
    @userGroup.destroy
    redirect_to group_path(@userGroup.group), :notice => "Successfully removed user from group"
  end
end
