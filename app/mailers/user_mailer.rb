class UserMailer < ActionMailer::Base
  
  def user_registered(user, to)
    mail(:from => "admin@railsbox.com", :to => to, :subject => "User Registered on Railsbox")
  end
end