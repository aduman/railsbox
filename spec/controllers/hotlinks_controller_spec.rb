require File.dirname(__FILE__) + '/../spec_helper'

describe HotlinksController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Hotlink.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Hotlink.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Hotlink.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(hotlink_url(assigns[:hotlink]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Hotlink.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Hotlink.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Hotlink.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Hotlink.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Hotlink.first
    response.should redirect_to(hotlink_url(assigns[:hotlink]))
  end

  it "destroy action should destroy model and redirect to index action" do
    hotlink = Hotlink.first
    delete :destroy, :id => hotlink
    response.should redirect_to(hotlinks_url)
    Hotlink.exists?(hotlink.id).should be_false
  end
end
