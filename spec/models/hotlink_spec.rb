require 'spec_helper'

describe Hotlink do
  
  
  it "should not be valid" do
    Hotlink.new.should_not be_valid
  end  
  
  
  it "should automatically create link" do
    Hotlink.new.link.should_not be_nil
  end
  
  it "should be valid" do
    valid_hotlink.should be_valid  
  end

  it "should not accept a nil asset" do
    link = valid_hotlink
    link.asset_id = nil
    link.should_not be_valid
  end 
  
  it "should accept link with no password" do
    link = valid_hotlink
    link.password = nil
    link.should be_valid #still
  end

end


def valid_hotlink
  Hotlink.new(:name=>'foobar', :asset_id => 1, :password=>'test1', :link=>'676528fgdda');
end