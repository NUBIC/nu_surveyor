Feature:
  As an user
  I want to take the kitchen sink survey with dependencies
  So I can tell you about my cars

  Scenario:
    Cars
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Sections"
  When I touch the table cell marked "Complicated questions"
  When I scroll to the bottom of the table
  And I wait for .5 seconds
  Then I should not see "Tell us about the cars you own"
  When I touch the table cell marked "NUOneCell Yes"
  Then the cell marked "NUOneCell Yes" should be dotted
  And I should see "Tell us about the cars you own"
