class PermissionsController < ApplicationController


  def show
    @permission = Permission.find(params[:id])
  end

  def new
    @permission = Permission.new
    @permission.folder_id = params[:folder_id]
    @users = User.all
    @groups = Group.all
  end

  def create
    @permission = Permission.new()
    parent = params[:permission][:parent]
    @permission.parent_id = parent.split('-')[1]
    @permission.parent_type = parent.split('-')[0]
    @permission.write_perms = params[:permission][:write_perms]
    @permission.read_perms = params[:permission][:read_perms]
    @permission.delete_perms = params[:permission][:delete_perms]
    @permission.assigned_by = current_user.id
    @permission.folder_id = params[:folder_id]
    if @permission.save
      redirect_to folder_details_url(@permission.folder), :notice => "Successfully created permission."
    else
      @users = User.all
      @groups = Group.all
      render :action => 'new'
    end
  end

  def edit
    @permission = Permission.find(params[:id])
  end

  def update
    @permission = Permission.find(params[:id])
    if @permission.update_attributes(params[:permission])
      redirect_to @permission, :notice  => "Successfully updated permission."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy
    redirect_to root_url, :notice => "Successfully destroyed permission."
  end

end
