# language:en
Feature: read permissions functionality
        In order to protect clients security and keep files secure
        As a responsible solutions provider
        I want to ensure that only authorized personel can access relevant folders
        
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
    And the following files exist:
    | file        | folder_id | description | owner   | notes                                 |
    | test1.txt   | nil       | one         | jim     | someone elses private file            |
    | test2.txt   | nil       | two         | me      | my private file                       |
    | test3.txt   | 1         | three       | jim     | file in shared folder 1               |
    | test4.txt   | 1         | four        | me      | my file in shared folder 1            |
    | test5.txt   | 2         | five        | jim     | file in shared folder 2               |  
    | test6.txt   | 6         | six         | jim     | file in shared folder 6               |  
        
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
    And I should not see "folder4"
    
  Scenario: See correct subfolders
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    | 1          | true       | true        | 1           |
    | 2          | true       | true        | 1           |
    | 4          | true       | true        | 1           |
    | 5          | true       | true        | 1           |
    When I visit browse/1
    Then I should see "folder4"
    And I should see "folder5"
    And I should not see "folder6"
    And I should not see "folder2"
    
  Scenario: File permissions work
    When I visit folders
    Then I should see "test2.txt"
    And I should not see "test1.txt"
    And I should not see "test4.txt"
    
  Scenario:  Sub folder permissions work for files
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    | 1          | true       | true        | 1           |
    When I visit browse/1
    Then I should see "test4.txt"
    And I should see "test3.txt"
    And I should not see "test2.txt"
    
  Scenario: Write only permissions work as expected
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    | 1          | false      | true        | 1           |
    | 4          | false      | true        | 1           |
    When I visit browse/1
    Then I should see "test4.txt"
    And I should not see "test3.txt"
    And I should not see "test2.txt"
    And I should see "folder4"
 
  Scenario: Admin sees everything
    Given I am an admin user
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    When I visit folders
    Then I should see "folder1"
    And I should see "folder2"
    And I should see "test2.txt"
    And I should not see "test1.txt"
    
  Scenario: Admin Has read/write access to submit folders
    Given I am an admin user
    And I have the following user permissions:
    | folder_id  | read_perms | write_perms | assigned_by |
    When I visit browse/1
    Then I should see "folder4"
    And I should see "folder5"
    And I should see "test3.txt"
    And I should see "test4.txt"