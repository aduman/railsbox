class HotlinksController < ApplicationController
  
  skip_before_filter :is_authorised, :only=>[:show,:update] #can view hotlink without login
  before_filter :check_hotlink, :except=>[:show, :update]
  
  after_filter :logFilePath, :except=>[:new]

  def show
    @hotlink = Hotlink.find(params[:id])
  end

  def new
    redirect_to root_path and return unless params[:asset_id]
    @hotlink = Hotlink.new
    @hotlink.asset_id = params[:asset_id]
  end

  def create
    @hotlink = Hotlink.new(params[:hotlink])
    if @hotlink.save
      redirect_to hotlink_link_path(@hotlink)
    else
      render :action => 'new'
    end
  end
  
  def link
    @hotlink = Hotlink.find(params[:hotlink_id])
  end
  
  def update
    #Download
    @hotlink = Hotlink.authenticate(params[:id], params[:hotlink][:password])
    @log_action = "Access"
    if @hotlink
      send_file @hotlink.asset.uploaded_file.path, :type => @hotlink.asset.uploaded_file_content_type  
    else
      @hotlink = Hotlink.find(params[:id])
      @log_action += " - Invalid Password"
      flash.now.alert = "Invalid password"
      render "show"
    end
  end
  
  private
  
  def logFilePath
    @log_file_path = ""
    if @hotlink.asset 
      @log_file_path = @hotlink.asset.folder.breadcrumbs if !@hotlink.asset.folder.nil?
      @log_file_path << "/" + @hotlink.asset.uploaded_file_file_name
    else
    	@log_file_path << "Not known"
    end	
    @log_target_id = @hotlink.id
  end
end