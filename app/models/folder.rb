class Folder < ActiveRecord::Base
  acts_as_tree :order=>'name'  
  attr_accessible :name, :parent_id, :notes, :description
  belongs_to :user  
  
  has_many :permissions, :dependent => :destroy
  has_many :users, :through=>:permissions
  has_many :assets, :dependent => :destroy
  
  validates_presence_of :name
  
  validates_uniqueness_of :name, :scope => :parent_id
  
  def breadcrumbs
    path = ''
    ancestors.reverse.each do |folder| 
      path <<  folder.name 
      path << '/'
    end 
    path << name.to_s
  end  
  
  def hasPermissions
    
  end
  
end