require File.dirname(__FILE__) + '/../spec_helper'

describe HotlinksController do
  
  
  before :each do
   @current_user = mock_model(User, :id => 1, :is_admin=>true, :active=>true, :email=>'wwah@hoss.com')
   controller.stub!(:current_user).and_return(@current_user)
   controller.stub!(:login_required).and_return(:true)
  end


  fixtures :all
  render_views


  it "show action should render show template" do
    get :show, :id => Hotlink.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new, :asset_id=>1
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    hotlink = Hotlink.new
	Hotlink.stub(:new).and_return(hotlink)
	hotlink.stub(:valid?).and_return(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    hotlink = Hotlink.new
	Hotlink.stub(:new).and_return(hotlink)
	hotlink.stub(:valid?).and_return(true)
    post :create
    response.should redirect_to(root_url)
  end


end
