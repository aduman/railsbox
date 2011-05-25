# language:en
Feature: logon facility
        In order to allow proper security
        As a developer
        I want to ensure that only authorized personel can access the site

	Background: users exist
		Given I am not logged on
    And I have one user "123456789@railsbox.com" with password "goodpass1"
		And I have one user "987654321@railsbox.com" with password "goodpass2"
		And I visit log_in

  	Scenario: Correct Logon works
                When I fill in "email" with "123456789@railsbox.com"
                And I fill in "password" with "goodpass1"
                And I press "Log in"
                Then I should see "Logged in as 123456789@railsbox.com"
		And I should not see "Invalid email or password"

        Scenario: incorrect Logon doesn't work
	        When I fill in "email" with "123456789@railsbox.com"
                And I fill in "password" with "badpass1"
                And I press "Log in"
                Then I should see "Invalid email or password"

	Scenario: incorrect userid correct password 
		When I fill in "email" with "17t8g7tg8"
		And I fill in "password" with "goodpass1"
		And I press "Log in"
		Then I should see "Invalid email or password"
