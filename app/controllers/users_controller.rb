class UsersController < ApplicationController
   
  skip_before_filter :is_authorised, :only=>[:new, :create]
  before_filter :check_admin, :except =>[:new, :create, :me]
  skip_after_filter :log, :only => [:searchUsersResult]
  after_filter :logFilePath, :except => [:index, :new, :edit, :searchUsersResult]
  
  def index
    @users = User.where(:active=>true)
    @non_users = User.where(:active=>false)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    config = File.open('config.txt', 'r')
    to = config.readlines[0].chomp
    config.close
    UserMailer.user_registered(@user, to).deliver
    redirect_to users_url, :notice => "Signed up!"
    
    #if @user.save
    #  UserMailer.user_registered(@user).deliver
    #  redirect_to users_url, :notice => "Signed up!"
    #else
    #  render "new"
    #end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def me
    @user = current_user
    render :template => 'users/show'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      if current_user.is_admin
        #allowed to change permissions
        @user.is_admin = params[:user][:is_admin]
        @user.can_hotlink = params[:user][:can_hotlink]
        @user.active = params[:user][:active]
        if @user.save!
          redirect_to @user, :notice  => "Successfully updated."
        else
          render :action => 'show'
        end
      else
        redirect_to @user, :notice  => "Successfully updated."
      end
    else
      render :action => 'edit'
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, :notice => "Successfully deleted user."
  end
  
  def searchUsersResult
    @users= User.named(params[:query])
    if params[:inactive]
      @users = @users.inactive
    end
      @users = @users.limit(5)
  end
  
  private
  def logFilePath
    @log_file_path = @user.email
    @log_target_id = @user.id
  end
  
end
