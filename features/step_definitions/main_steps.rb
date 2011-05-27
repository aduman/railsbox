require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^(?:that )?I am not logged on$/ do
  visit('/log_out')
end

Given /^(?:that )?I am logged (?:on|in)$/ do
	Given %{I have one user "test@test.com" with password "goodpass"}
	And %{I visit log_in}
	And %{I fill in "email" with "test@test.com"}
	And %{I fill in "password" with "goodpass"}
	And %{I press "Log in"}
end



Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  User.new(:email => email,
           :password => password,
           :password_confirmation => password).save!
end

Given /^I am an admin user$/ do
  u = User.find_by_email('test@test.com')
  u.is_admin = true 
  u.save
end 

Given /^I am not an admin user$/ do
  u = User.find_by_email('test@test.com')
  u.is_admin = false
  u.save
end

When /^I goto folder_url for "([^\"]*)"$/ do |folder|  
  f = Folder.find_by_name(folder)
  link = "/browse/"+f.id.to_s  
  visit(link)
end

Given /^I visit (.*)$/ do |link|
    visit('/'+link)
end

Given /^the following folders exist:$/ do |table|
  Folder.destroy_all
  table.hashes.each{|f|
    folder = Folder.new(f)
    folder.save
    ActiveRecord::Base.connection.execute('UPDATE folders SET id = '+f['id'].to_s+' WHERE id = '+folder.id.to_s)
  }
end  

Given /^the following files exist:$/ do |table|
  Asset.destroy_all 
  table.hashes.each{|a| 
    asset = Asset.new(a)
    if (a['owner'] && a['owner'] == 'me')
      asset.user_id = User.find_by_email('test@test.com').id #me
    else
      asset.user_id = User.find_by_email('test@test.com').id + 1 #someone else
    end
    asset.folder_id = nil if a['folder_id'] == 'nil'
    asset.uploaded_file = File.new(Rails.root + 'features/test_files/'+a['file'])
    asset.save
  }
end

 
Given /^I have the following user permissions:$/ do |table|
  Permission.destroy_all(:parent_type=>'User')
  u = User.find_by_email('test@test.com')
  table.hashes.each{|f| 
    p = Permission.new(f)
    p.parent_id = u.id
    p.parent_type = 'User'
    p.save
  }
end

Given /^I have the following group permissions:$/ do |table|
  Permission.destroy_all(:parent_type=>'Group')
  u = User.find_by_email('test@test.com')
  table.hashes.each{|f|
    g = Group.new()
    g.save(:validate=>false) 
    p = Permission.new(f)
    p.parent_id = g.id
    p.parent_type = 'Group'
    p.save
    UserGroup.new(:user_id=>u.id, :group_id=>g.id).save
  }
end  