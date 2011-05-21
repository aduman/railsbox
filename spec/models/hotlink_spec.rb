require File.dirname(__FILE__) + '/../spec_helper'

describe Hotlink do
  it "should be valid" do
    Hotlink.new.should be_valid
  end
end
