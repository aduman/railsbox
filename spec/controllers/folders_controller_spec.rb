require File.dirname(__FILE__) + '/../spec_helper'

describe FoldersController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Folder.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Folder.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Folder.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(folder_url(assigns[:folder]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Folder.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Folder.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Folder.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Folder.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Folder.first
    response.should redirect_to(folder_url(assigns[:folder]))
  end

  it "destroy action should destroy model and redirect to index action" do
    folder = Folder.first
    delete :destroy, :id => folder
    response.should redirect_to(folders_url)
    Folder.exists?(folder.id).should be_false
  end
end
