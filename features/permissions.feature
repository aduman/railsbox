# language:en
Feature: permissions functionality
        In order to protect clients security and keep files secure
        As a responsible solutions provider
        I want to ensure that only authorized personel can access relevant files or folders
        
  Background: Logged on
		Given I am logged on        
    And the following folders exist:
     | parent_id | name             | id    |
     |  nil      | folder1          | 1     |
     |  nil      | folder2          | 2     |
     |  2        | folder3          | 3     |  
     |  1        | folder4          | 4     |
     |  1        | folder5          | 5     |
     |  5        | folder6          | 6     |    
        
  Scenario: No permissions exist User should see nothing.
    When I visit folders
    Then I should not see "folder1"
    And I should not see "folder2"
    And I should not see "folder6"
    
  Scenario: Try to cheat the system
    When I visit browse/1
    Then I should not see "folder4" 
    And I should see "Folder not found"
    
   
  Scenario: See correct folders
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    | 1          | true       | true        | 1           |
    When I visit folders
    Then I should see "folder1"
    And I should not see "folder2"