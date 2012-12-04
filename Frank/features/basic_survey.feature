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
    And the device is in portrait orientation
  When I scroll to the bottom of the table
    And I go to the "Complicated questions" section
  Then I should see "Tell us how often do you cover these each day"

  Scenario:
    Picking dates
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I scroll the table to 1185px
    Then I should see "Pick your favorite date AND time"
  When I touch the cell marked "NUDatePickerCell Pick datetime"
    And I touch the button marked "Now"
    And I wait for animations
    And I scroll the table to 1270px
    And I scroll the table to 1185px
  Then I should see "Pick your favorite date AND time"

  Scenario:
    Entering text
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I scroll the table to 676px
    Then I should see "Get me started on an improv sketch"
  When I use the keyboard to fill in the textfield marked "NUNoneCell who (null) (null) textField" with "me" without hitting done
    And I scroll the table to 1000px
    And I press done on the keyboard
    And I scroll the table to 676px
  Then I should see "NUNoneCell who me (null)"

# Somehow, the touch table cell marked "Complicated questions" isn't working in landscape with the split view
#  Scenario:
#    Scrolling and switching sections, horizontal
#  Given I launch the app using iOS 5.1 and the ipad simulator
#  Given the device is in landscape orientation
#  When I scroll to the bottom of the table
#  When I wait for 1 second
#  When I touch the table cell marked "Complicated questions"
#  Then I should see "Tell us how often do you cover these each day"