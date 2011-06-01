class PermissionsController < ApplicationController


  def show
    @permission = Permission.find(params[:id])
  end

  def new
    @permission = Permission.new
    @permission.folder_id = params[:folder_id]
  end

  def create
    @permission = Permission.new(params[:permssion])
    if @permission.save
      redirect_to @permission, :notice => "Successfully created permission."
    else
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
