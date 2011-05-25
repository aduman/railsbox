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
When /^I goto folder_url for "([^\"]*)"$/ do |folder|  
  f = Folder.find_by_name(folder)
  link = "/browse/"+f.id.to_s  
  visit(link)
end

Given /^I visit (.*)$/ do |link|
    visit('/'+link)
end

Given /^the following folders exist:$/ do |table|
  table.hashes.each{|f| Folder.new(f).save}
end  

Given /^the following permissions exist:$/ do |table|
  table.hashes.each{|f| Permission.new(f).save}
end  