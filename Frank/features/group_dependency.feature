Feature:
  As an user
  I want to take the kitchen sink survey with dependencies
  So I can tell you about my cars

  Scenario:
    Cars
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I go to the "Complicated questions" section
    And I scroll to the bottom of the table
  Then I should not see "Tell us about the cars you own"

  When I touch the table cell marked "NUOneCell Yes"
  Then the cell marked "NUOneCell Yes" should be dotted
    And I should see "Tell us about the cars you own"
    
  Scenario:
    Dependencies work
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I touch the table cell marked "red"
  Then I should see "Please explain why you don't like this color?"
  
  
