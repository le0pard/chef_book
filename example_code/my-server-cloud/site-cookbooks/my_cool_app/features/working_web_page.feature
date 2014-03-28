Feature: Customer can use my cool web app

  In order to get more payment customers
  As a business owner
  I want web users to be able use my cool web app

  Background:
    Given I have provisioned the following infrastructure:
    | Server Name | Operating System | Version | Chef Version | Run List              |
    | localhost   | ubuntu           | 12.04   | 11.4.4       | my_cool_app::default  |

    And I have run Chef

  Scenario: User visits home page
    Given a url "http://example.org"
    When a web user browses to the URL
    Then the user should see "This is my cool web app"
    And cleanup test env