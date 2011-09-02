class AssetsController < ApplicationController
  
  before_filter :isAuthorised, :except=>[:new, :create, :move]

  after_filter :logFilePath, :except=>[:new, :edit, :destroy, :isAuthorised]
  
  def isAuthorised
    if params[:id]
      redirect_to root_path and return unless Asset.find(params[:id]).is_authorised?(current_user)
    elsif params[:ids]
      params[:ids].split(',').each do |asset|
        redirect_to root_path and return unless Asset.find(asset).is_authorised?(current_user)
      end
    end
  end
  
  def details
    @asset = Asset.find(params[:id])
  end
  
  def show
    @asset = Asset.find(params[:id])
    render :action => "details"  
  end

  def new
    @asset = Asset.new
    @asset.user_id = @current_user
    if params[:folder_id] #if we want to upload a file inside another folder  
      @current_folder = Folder.find(params[:folder_id])  
      @asset.folder_id = @current_folder.id
    end 
  end
  
  def get  
    @asset = Asset.find_by_id(params[:id])
    if @asset  
        send_file @asset.uploaded_file.path, :type => @asset.uploaded_file_content_type
    end  
  end
  
  def zip  
    @assets = Asset.find(params[:ids].split(','))
    if @assets
      require 'zip/zip'
      require 'zip/zipfilesystem'
      t = Tempfile.new("downloadZip#{request.remote_ip}")
      Zip::ZipOutputStream.open(t.path) do |zos|
        @assets.each do |file|
          zos.put_next_entry(file.uploaded_file_file_name)
          zos.print IO.read(file.uploaded_file.path)
        end
      end
      send_file t.path, :type => "application/zip", :disposition => "attachment", :filename => params[:name] + ".zip"
    end
  end

  def create
    @asset = Asset.new(params[:asset])
    @asset.user_id = @current_user.id
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
    logFilePath
    if !@asset.folder.nil?  #if asset isnt in the root
      redirect = browse_path(@asset.folder)
    else
      redirect = root_path
    end
    @asset.destroy
    redirect_to redirect, :notice => "Successfully deleted."
  end
  
  def move
    @assets = Asset.find(params[:ids].split(','))
  end
  
  private  
  def logFilePath
    @log_file_path = ""
    if @asset  #1 asset selected
      @log_target_id = @asset.id.to_s
      if !@asset.folder.nil?  #if asset isnt in the root
        @log_file_path = "/" + @asset.folder.breadcrumbs
      end
      @log_file_path = @log_file_path + "/" + @asset.uploaded_file_file_name
    elsif @assets
      @log_target_id = @assets.collect{|a| a.id}.join(', ')
      if @assets.count > 1
        if !@assets.first.folder.nil?  #if asset isnt in the root
          @log_file_path = "/" + @assets.first.folder.breadcrumbs
        end
        @log_file_path = @log_file_path + ": " + @assets.collect{|a| a.uploaded_file_file_name}.join(', ')
      else
        @log_file_path = @log_file_path + "/" + @assets.first.uploaded_file_file_name
      end
    end
  end
  
end
