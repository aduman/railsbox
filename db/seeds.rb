adminUser = User.create(
  :first_name => 'admin',
  :last_name => 'admin',
  :email => 'admin@admin.com', 
  :password =>'admin', 
  :password_confirmation =>'admin', 
  :company_contact => 'qwerty'
)

adminUser.toggle! :is_admin
adminUser.toggle! :active