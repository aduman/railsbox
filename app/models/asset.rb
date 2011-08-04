class Asset < ActiveRecord::Base

  belongs_to :folder
  belongs_to :user
 
  
  attr_accessible :user_id, :uploaded_file, :folder_id, :notes, :uploaded_file_file_name, :description
	has_attached_file :uploaded_file, :url => "/assets/get/:id", :path => "assets/:id/:basename.:extension"  
	has_many :hotlinks

  validates_attachment_presence :uploaded_file  
  
  validates_uniqueness_of :uploaded_file_file_name, :scope => :folder_id

  def is_authorised?(userFind)
    if folder
      !!userFind.accessible_folders.find_by_id(folder)
    else
      #if asset in root
      userFind == user
    end
  end  
  
  def permissions
    '768'
  end 
  
  def file_extension
   File.extname(uploaded_file_file_name).downcase
  end


end
