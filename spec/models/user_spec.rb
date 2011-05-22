require 'spec_helper'

describe User do
  it "should be valid" do
    User.new(:email=>'test@testemail.com',:password=>'test1', :password_confirmation=>'test1').should be_valid
  end
end
