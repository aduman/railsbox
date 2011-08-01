require 'spec_helper'

describe "logs/show.html.haml" do
  before(:each) do
    @log = assign(:log, stub_model(Log,
      :user_id => 1,
      :event => "",
      :file_path => "File Path",
      :ip_address => "Ip Address",
      :user_agent => "User Agent"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/File Path/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ip Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User Agent/)
  end
end
