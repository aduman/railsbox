require 'spec_helper'

describe Log do
  
  it "shouldn't be valid" do
  	Log.new.should_not be_valid
  end
  
  it "should be valid with all attributes" do
  	log = valid_log
  	log.should be_valid
  end
  
  it "should not be valid without an IP address" do
  	log = valid_log 
  	log.ip_address = nil
  	log.should_not be_valid
  end
  
  it "should have a reasonable IP address" do
  	log = valid_log
  	log.ip_address = "FOOBAR"
  	log.should_not be_valid
  end
  
end

def valid_log
	Log.new(:controller=>'test_controller', :action=>'test_action', :ip_address=>"192.168.1.1", :user_agent=>"Good browser")
end