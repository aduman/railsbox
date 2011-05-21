class FoldersController < ApplicationController
  def index
    @folders = Folder.all #todo restrict to user
    @assets  = Asset.where(:folder_id=>nil) #todo restrict to user
  end

  def show
    @folder = Folder.find(params[:id])
  end

  def new
    @folder = Folder.new
    
    if params[:folder_id] #subfolder
     @current_folder = Folder.find(params[:folder_id])  
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
    #get the folders owned/created by the current_user  
    @current_folder = Folder.find(params[:folder_id])    
  
    if @current_folder  
    
      #getting the folders which are inside this @current_folder  
      @folders = @current_folder.children  
  
      #We need to fix this to show files under a specific folder if we are viewing that folder  
      #@assets = current_user.assets.order("uploaded_file_file_name desc")  
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")  
    
      render :action => "index"  
    else  
      flash[:error] = "Folder not found"  
      redirect_to root_url  
    end  
  end  

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    redirect_to folders_url, :notice => "Successfully destroyed folder."
  end
end
