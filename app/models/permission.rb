class Permission < ActiveRecord::Base
  
  belongs_to :parent, :polymorphic => true
  belongs_to :folder
  
  validates_presence_of :assigned_by
  validates_inclusion_of :parent_type, :in=>['User','Group']
  validates_uniqueness_of :folder_id, :scope=>[:parent_id, :parent_type]
end
