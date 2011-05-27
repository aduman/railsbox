class User < ActiveRecord::Base

  has_many :permissions, :as=>:parent
  has_many :folders, :through=>:permissions, :conditions=>['read_perms = ? or write_perms = ?', true, true]
  has_many :assets
  has_many :user_groups
  has_many :groups, :through=>:user_groups
  attr_accessible :email, :password, :password_confirmation
  
  
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def accessible_folders
    if is_admin
      return Folder.where('true') #TODO: find better way of this Folder.all doesn't return AR object.
    else
      return folders#+ groups.each{|g| g.folders}
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

