require 'spec_helper'

describe Permission do
  it "should not be valid without assigned to" do
    Folder.new.should_not be_valid
  end
  
  it "should be valid" do
    valid_permission.should be_valid
  end
  
  it "should default the permissions to all false" do
    valid_permission.read_perms.should_not be_true
    valid_permission.write_perms.should_not be_true
    valid_permission.delete_perms.should_not be_true
  end
  
  it "should not allow duplicate (conflicting permissions)" do 
    valid_permission.save
    new_perm = valid_permission
    new_perm.read_perms = true
    new_perm.should_not be_valid
  end
  
  it "should allow duplicate (different scope elements)"  do
    valid_permission.save
    new_perm = valid_permission
    new_perm.read_perms = true
    new_perm.parent_type = 'folder'
    new_perm.should be_valid
  end
  
  it "shouldnt allow non valid parent types" do
    p = valid_permission
    p.parent_type = 'foobar'
    p.should_not be_valid
  end
  
  it "should be able to get a user" do
    u = User.new()
    u.save(:validate=>false)
    p = valid_permission
    p.parent_id = u.id    
    p.parent.should == u
  end
  
  
  def valid_permission
    Permission.new(:assigned_by=>1, :folder_id=>1, :parent_id=>1, :parent_type=>'User')
  end
  
end
