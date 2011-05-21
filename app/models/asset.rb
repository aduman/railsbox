class Asset < ActiveRecord::Base

  belongs_to :folder
  belongs_to :user

  attr_accessible :user_id, :uploaded_file, :folder_id 

  has_attached_file :uploaded_file, :url => "/assets/get/:id", :path => "#{:Rails_root}/assets/:id/:basename.:extension"  
  
  validates_attachment_presence :uploaded_file  

end
