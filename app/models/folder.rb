class Folder < ActiveRecord::Base
  acts_as_tree :order=>'name'  
  attr_accessible :name, :parent_id
  
  has_many :permissions
  has_many :users, :through=>:permissions
  has_many :assets, :dependent => :destroy
  
  validates_presence_of :name
  
  def description
    'a'
  end



  
  
    
  
  def breadcrumbs
    path = ''
    ancestors.reverse.each do |folder| 
      path +=  folder.name 
      path += '/'
    end 
    path +=  name
  end  
  
end
