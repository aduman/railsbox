class HotlinksController < ApplicationController
  
  skip_before_filter :is_authorised, :only=>[:show,:update] #can view hotlink without login

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
      redirect_to @hotlink, :notice => "Successfully created hotlink."
    else
      render :action => 'new'
    end
  end
  
  def update
    #ie download
    @hotlink = Hotlink.authenticate(params[:id], params[:hotlink][:password])
    if @hotlink
      send_file @hotlink.asset.uploaded_file.path, :type => @hotlink.asset.uploaded_file_content_type  
    else
      @hotlink = Hotlink.find(params[:id])
      flash.now.alert = "Invalid password"
      render "show"
    end
  end


end
