class User < ActiveRecord::Base

  has_many :permissions, :as=>:parent
  has_many :folders
  has_many :folders, :through=>:permissions, :conditions=>['read_perms = ? or write_perms = ?', true, true]
  has_many :assets
  has_many :user_groups
  has_many :groups, :through=>:user_groups 
  has_many :logs
  
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :company
  
  scope :inactive, lambda { where('active = false').order("name") }
  
  scope :named, lambda {|name| 
      escaped_query = "%" + name.gsub('%', '\%').gsub('_', '\_') + "%"
      where('name ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?',escaped_query,escaped_query,escaped_query).order("name")
  }
  
  def name
    if first_name and last_name
      first_name.capitalize + ' ' + last_name.capitalize 
    else
      email
    end  
  end  
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def accessible_folders
    if is_admin
      return Folder.scoped.order('parent_id nulls first, name')
    else
      #this needs to be improved...
      g_folders = folders
      groups.scoped.each{|g|
        g_folders += g.folders
      }
      ids = g_folders.inject([]){|a,b| a+=[b.id]}
      Folder.where('id in (?)', ids).order('parent_id nulls first, name')
    end
  end  
  
  def owned_folders
    if is_admin
      return Folder.scoped 
    else
      Folder.where(:user_id=>id)
    end
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end

