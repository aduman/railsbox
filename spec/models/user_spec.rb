require 'spec_helper'

describe User do
  it "should not be valid" do
    User.new().should_not be_valid
  end
  
  it "should succeed" do
    valid_user.should be_valid
  end  
  
  it "should not allow duplicate logins" do
    valid_user.save
    valid_user.should_not be_valid
  end 

  it "should fail with no email" do
    user = valid_user
    user.email = nil
    user.should_not be_valid
  end 

  it "should fail with no password" do
    user = valid_user
    user.password = user.password_confirmation = nil
    user.should_not be_valid
  end

  it "folders should be maniupulatable" do
    user = valid_user
    user.accessible_folders.class.should == ActiveRecord::Relation
    user.is_admin = true
    user.accessible_folders.class.should == ActiveRecord::Relation
  end

  it "should fail confirmation password" do
    user = valid_user
    user.password_confirmation = user.password.reverse
    user.should_not be_valid
  end

  it "should set active to false" do
    valid_user.active.should be_false
  end
  
  its "should set is_admin to false" do
    valid_user.is_admin.should be_false
  end

end


def valid_user
  User.new(:name=>'foobar', :email=>'test@testemail.com',:password=>'test1', :password_confirmation=>'test1')
end