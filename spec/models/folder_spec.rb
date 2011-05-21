require File.dirname(__FILE__) + '/../spec_helper'

describe Folder do
  it "should be valid" do
    Folder.new.should be_valid
  end
end
