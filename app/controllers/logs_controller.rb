class LogsController < ApplicationController
  # GET /logs
  # GET /logs.xml
  def index
    @Users = User.order("name, first_name, last_name ASC")
    @controllers = Log.select('DISTINCT (controller)').order('controller ASC')
    @actions = Log.select('DISTINCT (action)').order('action ASC')
    
    @logs = Log.order("created_at desc")
    
    if !params[:caction].blank?
      @logs = @logs.where('action = ?',params[:caction])
    end
    
    if !params[:ccontroller].blank?
      @logs = @logs.where('controller = ?',params[:ccontroller])
    end
    
    if !params[:cuserid].blank?
      @logs = @logs.where('user_id = ?',params[:cuserid])
    end
    
    @logs = @logs.order("created_at desc").limit(25)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logs }
    end
  end

  # GET /logs/1
  # GET /logs/1.xml
  def show
    @log = Log.find(params[:id])
    @log_target_id = @log.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @log }
    end
  end

  
end
