Feature:
  As an user
  I want to take the exclusive answer test

  Scenario:
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in landscape orientation
    Then I wait for 1 seconds
    And I scroll to the bottom of the table
    Then I wait for 1 seconds
  When I touch the table cell marked "Pork"
  When I touch the table cell marked "Beef"
  When I touch the table cell marked "No Meat"
    Then the cell marked "Pork" should be unchecked
    Then the cell marked "Beef" should be unchecked
    Then I wait for 1 seconds
  When I touch the button marked "Inspect"
    Then I should see a "1 response" label
    
  Scenario:
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in landscape orientation
    Then I wait for 1 seconds
    And I scroll to the bottom of the table
    Then I wait for 1 seconds
  When I touch the table cell marked "No Meat"
  When I touch the table cell marked "Pork"
  When I touch the table cell marked "Beef"
    Then the cell marked "No Meat" should be unchecked
    Then I wait for 1 seconds
  When I touch the button marked "Inspect"
    Then I should see a "2 responses" label