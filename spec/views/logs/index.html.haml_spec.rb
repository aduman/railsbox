require 'spec_helper'

describe "logs/index.html.haml" do
  before(:each) do
    assign(:logs, [
      stub_model(Log,
        :user_id => 1,
        :event => "",
        :file_path => "File Path",
        :ip_address => "Ip Address",
        :user_agent => "User Agent"
      ),
      stub_model(Log,
        :user_id => 1,
        :event => "",
        :file_path => "File Path",
        :ip_address => "Ip Address",
        :user_agent => "User Agent"
      )
    ])
  end

  it "renders a list of logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "File Path".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ip Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User Agent".to_s, :count => 2
  end
end
