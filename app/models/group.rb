class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :user_groups
  has_many :users, :through=>:user_groups
  has_many :permissions, :as=>:parent
  has_many :folders, :through=>:permissions, :conditions=>['read_perms = ? or write_perms = ?', true, true]
  
end
