# language:en
Feature: have admin back end
        In order to run an efficxient site
        As an admin user
        I want to be able to perform administrative tasks
        
  Background: Logged on
    Given I am logged on        
    And I am an admin user
    And the following users exist:
    | first_name | last_name | is_admin | can_hotlink | active | company |
    | Jim        | Wilson    | false    | false       | false  | bank    |
    | Harry      | Shaw      | false    | false       | false  | printer |
    | Mark       | Smith     | false    | false       | false  | supplier|
    
  Scenario: Non admins don't have access to admin panel
    Given I am not an admin user
    When I visit admin/panel
    Then I should not see "Admin"
    
  Scenario: Admins have access
    When I visit admin/panel
    Then I should see "Admin"

  Scenario: Be able to change users
    When I visit admin/panel
    Then I should see "Jim Wilson"
    And I follow "Jim Wilson"
    And I should see "bank"
    And "can_hotlink" should not be checked
    And "is_admin" should not be checked
    And I check "can_hotlink"
    And I press "save changes"
    And "can_hotlink" should be checked
    And "is_admin" should not be checked
     
    
	
