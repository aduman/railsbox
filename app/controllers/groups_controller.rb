class GroupsController < ApplicationController
  
  before_filter :check_admin
  
  before_filter :searchGroupsResult, :only=>[:userGroupSearchResult]
  
  skip_after_filter :log, :only=>[:searchGroupsResult,:userGroupSearchResult]
  
  after_filter :logfilepath, :only=>[:show, :update, :create]
  
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to @group, :notice => "Successfully created group."
    else
      render :action => 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      redirect_to @group, :notice  => "Successfully updated group."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    logfilepath
    @group.destroy
    redirect_to groups_url, :notice => "Successfully deleted group."
  end
  
  def searchGroupsResult
    @groupCount = Group.named(params[:query]).count
    @groups= Group.named(params[:query]).limit(5)
  end
  
  def userGroupSearchResult    
    @userCount = User.named(params[:query]).count
    @users = User.named(params[:query]).limit(5)
  end
  
  private
  def logfilepath
    @log_file_path = "Group: " + @group.name
    @log_target_id = @group.id
  end
end
