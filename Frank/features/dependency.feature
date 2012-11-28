Feature:
  As an user
  I want to take the kitchen sink survey with dependencies
  So I can tell you about my favorite colors

  Scenario:
    Cars
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  Then I should not see "Please explain why you dislike so many colors?"
  When I touch the table cell marked "NUAnyCell red"
  Then the cell marked "NUAnyCell red" should be checked
  When I touch the table cell marked "NUAnyCell blue"
  Then the cell marked "NUAnyCell blue" should be checked
  When I touch the table cell marked "NUAnyCell green"
  Then the cell marked "NUAnyCell green" should be checked
    And I should see "Please explain why you dislike so many colors?"
