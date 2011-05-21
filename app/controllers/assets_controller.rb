class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def show
    @asset = Asset.find(params[:id])
  end

  def new
    @asset = Asset.new
    if params[:folder_id] #if we want to upload a file inside another folder  
      @current_folder = Folder.find(params[:folder_id])  
      @asset.folder_id = @current_folder.id  
    end 
  end
  
  def get  
  asset = Asset.find_by_id(params[:id])  
    if asset  
         send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type  
    end  
  end 

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      if @asset.folder_id
        redirect_to @asset.folder
      else
        redirect_to root_path
      end  
    else
      render :action => 'new'
    end
  end

  def edit
    @asset = Asset.find(params[:id])
  end

  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(params[:asset])
      if @asset.folder_id
        redirect_to @asset.folder
      else
        redirect_to root_path
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to root_path
  end
  
end
