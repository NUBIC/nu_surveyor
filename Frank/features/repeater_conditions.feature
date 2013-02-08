Feature:
  As an user
  I want to take the red green survey
  So I can test labels depenendent on repeater questions

  Background:
    Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
    And I touch the button marked "Inspect"
    And I touch the button marked "loadRedGreen"
    And I wait for animations

  Scenario: The label dependent on the repeater question should not show when dependency not is satisfied
    When I touch the table cell marked "Red"
    And  I wait for animations
    Then I should not see a "You Win!!" label

  Scenario: The label dependent on the repeater question should show when dependency is satisfied
    When I touch the table cell marked "Green"
    And  I wait for animations
    Then I should see a "You Win!!" label

  Scenario: The label dependent on the repeater question should show with multiple responses when dependency is satisfied
    When I touch the table cell marked "Red"
    And  I wait for animations
    When I touch the button marked "+ add row"
    And  I wait for animations
    And  touch the 2nd table cell marked "Green"
    And  I wait for animations
    Then I should see a "You Win!!" label