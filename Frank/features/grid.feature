Feature:
  As an user
  I want to take the grid survey
  So I can test grid questions

  Background:
    Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
    And I touch the button marked "Inspect"
    And I touch the button marked "loadGrid"
    And I wait for animations

  Scenario: The pretext label on a pick one grid question is very long
    Then the label "Rainbow suspenders.. the good kind with the glitter and good elastic" should have a height of "113"


  Scenario: The pretext label on a pick one grid question is very long
    Then the label "Yellow... Yes, the best color in the world if you are a bumble bee" should have a height of "94"