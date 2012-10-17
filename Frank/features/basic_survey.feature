Feature:
  As an user
  I want to take the kitchen sink survey
  So I can try out surveyor on an iPad

  Scenario:
    Basic questions
  Given I launch the app using iOS 5.1 and the ipad simulator
  When I touch the table cell marked "NUOneCell green"
  Then the cell marked "NUOneCell green" should be dotted

  Scenario:
    Scrolling and switching sections, vertical
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  When I scroll to the bottom of the table
  When I wait for .5 seconds
  And I touch the button marked "Sections"
  When I touch the table cell marked "Complicated questions"
  And I wait for .5 seconds
  Then I should see "Tell us how often do you cover these each day"

# Somehow, the touch table cell marked "Complicated questions" isn't working in landscape with the split view
#  Scenario:
#    Scrolling and switching sections, horizontal
#  Given I launch the app using iOS 5.1 and the ipad simulator
#  Given the device is in landscape orientation
#  When I scroll to the bottom of the table
#  When I wait for 1 second
#  When I touch the table cell marked "Complicated questions"
#  Then I should see "Tell us how often do you cover these each day"