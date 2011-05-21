class Folder < ActiveRecord::Base
  acts_as_tree :order=>'name'  
  attr_accessible :name, :parent_id
  
  has_many :assets, :dependent => :destroy  
  
end
