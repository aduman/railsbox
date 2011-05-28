# language:en
Feature: have admin back end
        In order to run an efficxient site
        As an admin user
        I want to be able to perform administrative tasks
        
  Background: Logged on
		Given I am logged on        
    And I am an admin user
    
  Scenario: Non admins don't have access to admin panel
    Given I am not an admin user
    When I visit admin/panel
    Then I should not see "Admin"
    
  Scenario: Admins have access
    When I visit admin/panel
    Then I should see "Admin"