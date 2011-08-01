class PermissionsController < ApplicationController
  
  after_filter :logFilePath, :only=>[:create, :update]

  def new
    @permission = Permission.new
    @permission.folder_id = params[:folder_id]
    @users = User.all
    @groups = Group.all
  end

  def create
    @permission = Permission.new()
    parent = params[:permission][:parent]
    @permission.parent_id = parent.split('/')[2]
    
    if parent.split('/')[1] == 'users'
      @permission.parent_type = 'User'
    else
      @permission.parent_type = 'Group'
    end    
    
    @permission.write_perms = params[:permission][:write_perms]
    @permission.read_perms = params[:permission][:read_perms]
    @permission.delete_perms = params[:permission][:delete_perms]
    @permission.assigned_by = current_user.id
    @permission.folder = current_user.owned_folders.find(params[:folder_id])
    if @permission.save
      redirect_to folder_details_path(@permission.folder), :notice => "Successfully created permission"
    else
      @users = User.all
      @groups = Group.all
      render :action => 'new'
    end
  end

  def edit
    @permission = Permission.find(params[:id])
    @users = User.all
    @groups = Group.all
  end

  def update
    @permission = Permission.find(params[:id])
    
    @permission.read_perms = params[:permission][:read_perms]
    @permission.write_perms = params[:permission][:write_perms]
    @permission.delete_perms = params[:permission][:delete_perms]
    
    if @permission.save
      redirect_to folder_details_path(@permission.folder), :notice => "Successfully created permission"
    else
      redirect_to folder_details_path(@permission.folder), :notice => "Sasdasdasdsas"
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    logFilePath
    @permission.destroy
    redirect_to folder_details_path(@permission.folder), :notice => "Successfully destroyed permission."
  end
  
  private
  def logFilePath
    @log_target_id = @permission.id
    
    @log_file_path = "/" + @permission.folder.breadcrumbs
    
    @log_parameters = @permission.parent_type + ": " + @permission.parent.name + " - "
    
    if @permission.read_perms
      @log_parameters += "Read"
    end
    if @permission.write_perms
      @log_parameters += ", Write"
    end
    if @permission.delete_perms
      @log_parameters += ", Delete"
    end
  end

end
