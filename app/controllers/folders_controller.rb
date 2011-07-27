class FoldersController < ApplicationController

  before_filter :find_folder
  
  def index
    @folders = current_user.accessible_folders.where('folders.parent_id is null or folders.parent_id = 0').order(:name)
    @assets  = Asset.where(:folder_id=>nil, :user_id=>current_user).order(:uploaded_file_file_name)
  end

  def show
    browse
  end

  def details

  end

  def new
    @folder = Folder.new
    
    if params[:folder_id] #subfolder
     @folder.parent_id = @current_folder.id  
    end
  
  end

  def create
    @folder = Folder.new(params[:folder])
    @folder.user_id = current_user.id
    if @folder.save
      p = Permission.new(:folder_id=>@folder.id, :parent=>current_user, :assigned_by=>current_user, :read_perms=>true, :write_perms=>true, :delete_perms=>true)
      p.save
      
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
    if @current_folder  
      @folders = current_user.accessible_folders.where('folders.parent_id=?',@current_folder)
      if current_user.is_admin or !current_user.permissions.where('read_perms = ? and folder_id = ?', true, @current_folder).empty?
        @assets = @current_folder.assets.order("uploaded_file_file_name desc")  
      else
        #read only can still see own files.
        @assets = @current_user.assets.order("uploaded_file_file_name desc").find_all_by_folder_id(@current_folder)
      end
      
      render :action => "index"  
    else  
      flash[:error] = "Folder not found"  
      redirect_to root_url  
    end  
  end  
  
  def folderChildren
    if params[:folder_id] == '0'
      @parentFolder = nil
    else
      @parentFolder = Folder.find(params[:folder_id])
    end
    @folders = current_user.accessible_folders.where(:parent_id => @parentFolder).order(:name)
  end

  def search
    search_query = params[:search]
    
    @escaped_query = "%" + search_query[:query].gsub('%', '\%').gsub('_', '\_') + "%"
    @searchNotes = params[:search][:notes] == '1'
    
    if @searchNotes
      @folders = current_user.accessible_folders.find(:all, :conditions => ["name ILIKE ? OR notes ILIKE ?", @escaped_query, @escaped_query])
      @assets = current_user.assets.find(:all, :conditions => ["uploaded_file_file_name ILIKE ? OR notes ILIKE ?", @escaped_query, @escaped_query])
    else
      @folders = current_user.accessible_folders.find(:all, :conditions => ["name ILIKE ?", @escaped_query])
      @assets = current_user.assets.find(:all, :conditions => ["uploaded_file_file_name ILIKE ?", @escaped_query])
    end
    render :action => "index"  
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    redirect_to root_path, :notice => "Successfully deleted."
  end
  
  def find_folder
    if params[:folder_id]
      @current_folder =  current_user.accessible_folders.find_by_id(params[:folder_id])
    elsif params[:id]
      @current_folder = current_user.accessible_folders.find_by_id(params[:id])
    else
      #none to be found
    end
  end
  
  def move
    @folders = Folder.find(params[:folder_id].split(','))
  end
  
  def rename
    @folder = Folder.find(params[:folder_id])
  end
  
  
end
