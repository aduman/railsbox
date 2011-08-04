# language:en
Feature: have admin back end
        In order to run an efficxient site
        As an admin user
        I want to be able to perform administrative tasks
        
  Background: Logged on
    Given I am logged on        
    And I am an admin user
    And the following users exist:
    | first_name | last_name | is_admin | can_hotlink | active | company | email               | password | password_confirmation |
    | Jim        | Wilson    | false    | false       | false  | bank    | test1@railsbox.com  | pass1    | pass1                 |
    | Harry      | Shaw      | false    | false       | false  | printer | test2@railsbox.com  | pass2    | pass2                 |
    | Mark       | Smith     | false    | false       | false  | supplier| test3@railsbox.com  | pass3    | pass3                 |
    
  Scenario: Non admins don't have access to admin panel
    Given I am not an admin user
    When I visit admin/panel
    Then I should not see "Admin"
    
  Scenario: Admins have access
    When I visit admin/panel
    Then I should see "Admin"

  Scenario: Be able to view users
    When I visit admin/panel
    And I follow "Users"
    And I press "Search"
    Then I should see "Jim Wilson"
    And I follow "Jim Wilson"
    And I should see "bank"
    And "user_can_hotlink" should not be checked
    And "user_is_admin" should not be checked
  
  Scenario: Be able to change users
    Given I visit admin/panel
    And I follow "Users"
    And I press "Search"
    And I follow "Jim Wilson"
    And I check "user_can_hotlink"
    And I press "Save changes"
    And "user_can_hotlink" should be checked
    And "user_is_admin" should not be checked
     
    
	
