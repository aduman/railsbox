require File.dirname(__FILE__) + '/../spec_helper'

describe FoldersController do
  
  before :each do
   @current_user = mock_model(User, :id => 1, :email=>'text@test.com', :is_admin=>true, :accessible_folders=>Folder.scoped)
   controller.stub!(:current_user).and_return(@current_user)
   controller.stub!(:login_required).and_return(:true)
  
  end

  fixtures :all
  render_views


it "browse action should render show template" do
  get :browse, :folder_id => Folder.first
  response.should render_template(:index)
end


  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    folder = Folder.new
	Folder.stub(:new).and_return(folder)
	folder.stub(:valid?).and_return(false)
	
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    folder = Folder.new
	Folder.stub(:new).and_return(folder)
	folder.stub(:valid?).and_return(true)
    post :create
    response.should redirect_to(root_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Folder.first
    response.should render_template(:edit)
  end

  

  it "update action should redirect when model is valid" do
    folder = Folder.first
	folder.stub(:valid?).and_return(true)
    put :update, :id => folder
    response.should redirect_to(folder_url(assigns[:folder]))
  end

  it "destroy action should destroy model and redirect to index action" do
    folder = Folder.first
    delete :destroy, :id => folder
    response.should redirect_to(root_url)
    Folder.exists?(folder.id).should be_false
  end
end
