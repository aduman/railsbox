class Folder < ActiveRecord::Base
  acts_as_tree :order=>'name'  
  attr_accessible :name, :parent_id, :notes, :description
  belongs_to :user  
  
  has_many :permissions, :dependent => :destroy
  has_many :users, :through=>:permissions
  has_many :assets, :dependent => :destroy
  
  validates_presence_of :name
  
  validates_uniqueness_of :name, :scope => :parent_id
    
  def breadcrumbs(stop = "")
    path = ''
    ancestors.each do |folder| 
      path =  folder.name + '/' + path
      if folder.id == stop
        break
      end 
    end unless id == stop
    path << name.to_s
  end
  
  def folderChildren
    Folder.where(:parent_id=>id)
  end
  
  def hasPermissions
    
  end
  

  def descendants
     descendant_folders_include_self - self
  end

  #returns all descendants that are under this folder including current folder
  def descendant_folders_include_self
    (folderChildren ? folderChildren.map{|a| a.descendant_folders_include_self} << self : self).flatten
  end
end