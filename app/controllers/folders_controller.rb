class FoldersController < ApplicationController

  
  def index
    @folders = current_user.folders.where('folders.parent_id is null')
    @assets  = Asset.where(:folder_id=>nil, :user_id=>current_user)
  end

  def show
    browse
  end

  def new
    @folder = Folder.new
    
    if params[:folder_id] #subfolder
     @current_folder = current_user.folders.find(params[:folder_id])  
     @folder.parent_id = @current_folder.id  
    end
  
  end

  def create
    @folder = Folder.new(params[:folder])
    if @folder.save
      if @folder.parent 
        redirect_to browse_path(@folder.parent)  
      else  
        redirect_to root_url
      end 
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def update
    @folder = Folder.find(params[:id])
    if @folder.update_attributes(params[:folder])
      redirect_to @folder, :notice  => "Successfully updated folder."
    else
      render :action => 'edit'
    end
  end

  def browse  
    #Use find_by_id instead of find as find_by_id returns nil, rather than throwing exception
    if params[:folder_id]
      @current_folder = current_user.folders.find_by_id(params[:folder_id])
    else
      @current_folder = current_user.folders.find_by_id(params[:id])
    end
  
    if @current_folder  
    
      #getting the folders which are inside this @current_folder  
      @folders = current_user.folders.where('folders.parent_id=?',@current_folder)
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")  
    
      render :action => "index"  
    else  
      flash[:error] = "Folder not found"  
      redirect_to root_url  
    end  
  end  

  def search
    @search_query = params[:search]
    @folders = current_user.folders
    @assets = Asset.all
    render :action => "index"  
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    redirect_to root_path, :notice => "Successfully deleted."
  end
  
  
end
