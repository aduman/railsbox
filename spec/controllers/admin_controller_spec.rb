require 'spec_helper'

describe AdminController do
  
  before :each do
   @current_user = mock_model(User, :id => 1, :email=>'text@test.com', :is_admin=>true, :active=>true)
   controller.stub!(:current_user).and_return(@current_user)
   controller.stub!(:login_required).and_return(:true)
  end

  describe "GET 'panel'" do
    it "should be successful" do
      get 'panel'
      response.should render_template(:panel)
    end
  end

end
