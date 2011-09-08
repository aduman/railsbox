class LogsController < ApplicationController
  # GET /logs
  # GET /logs.xml
  def index
    @Users = User.order("name, first_name, last_name ASC")
    @controllers = Log.select('DISTINCT (controller)').order('controller ASC')
    @actions = Log.select('DISTINCT (action)').order('action ASC')
    
    #@log = Log.new(params[:log]) || Log.new
    
    @search = Log.search(params[:search])
    
    @log_parameters = "CHANGE CHANGE CHANGE"
    
    @logs = @search.paginate(:page => params[:page])

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
  
  private
  def check_datetime_selects(a)
    returnDate = DateTime.new(
      a["date(1i)"].to_i,
      a["date(2i)"].to_i,
      a["date(3i)"].to_i,
      a["date(4i)"].to_i,
      a["date(5i)"].to_i
    )
  end

end
