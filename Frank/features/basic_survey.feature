Feature: 
  As an user
  I want to take the kitchen sink survey
  So I can try out surveyor on an iPad

Scenario: 
    Basic questions
Given I launch the app using iOS 5.0 and the ipad simulator
When I touch the table cell marked "NUOneCell green"
Then the cell marked "NUOneCell green" should be dotted