require "spec_helper"

describe UserMailer do

  user = User.new(:name=>'foobar', :email=>'test@testemail.com',:password=>'test1', :password_confirmation=>'test1')
  admin = 'test@railsbox.com'

  ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
 
  it 'should send activate email' do
    mail = UserMailer.user_activated(user)
    mail.to.should == [user.email]
  end

  it 'should send register email' do
    mail = UserMailer.user_registered(user,admin)
    mail.to.should == [admin]
  end


end
