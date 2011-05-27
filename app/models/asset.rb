class Asset < ActiveRecord::Base

  belongs_to :folder
  belongs_to :user
 
  
  attr_accessible :user_id, :uploaded_file, :folder_id 

  has_attached_file :uploaded_file, :url => "/assets/get/:id", :path => "assets/:id/:basename.:extension"  

  has_many :hotlinks

  validates_attachment_presence :uploaded_file  


  
  def permissions
    '768'
  end 
  
  def file_extension
   File.extname(uploaded_file_file_name).downcase
  end


end
