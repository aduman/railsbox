# language:en
Feature: permissions functionality
        In order to protect clients security and keep files secure
        As a responsible solutions provider
        I want to ensure that only authorized personel can access relevant files or folders
        
  Background: Logged on
		Given I am logged on        
    And the following folders exist:
     | id | parent_id | name             |
     | 1  |  nil      | folder1          |   
     | 2  |  nil      | folder2          |   
     | 3  |  2        | folder3          |   
     | 4  |  1        | folder4          |   
     | 5  |  1        | folder5          |   
     | 6  |  5        | folder6          |   
        
  Scenario: No permissions exist User should see nothing.
    When I visit folders
    Then I should not see "folder1"
    And I should not see "folder2"
    And I should not see "folder6"
    
  Scenario: Try to cheat the system
    When I goto folder_url for "folder1"
    Then I should not see "folder4" 
    And I should see "permission denied"
    
    