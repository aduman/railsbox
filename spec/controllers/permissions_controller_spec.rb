require 'spec_helper'

describe PermissionsController do

 before :each do
   @current_user = mock_model(User, :id => 1, :is_admin=>true, :active=>true, :email=>'wwah@hoss.com')
   controller.stub!(:current_user).and_return(@current_user)
   controller.stub!(:login_required).and_return(:true)
  end
  
  fixtures :all
  render_views
  

end
