Feature:
  As an user
  I want to take the textfield resigns test

  Scenario:
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in landscape orientation
    Then I wait for 2 seconds
  When I touch the button marked "Inspect"
    And I touch the button marked "loadComplexResponses"
    Then I wait for 1 seconds
  When I touch the table cell marked "I cannot tell"
  When I use the keyboard to fill in the textfield marked "I cannot tell" with "hello" without hitting done
    Then I wait for 1 seconds
  When I touch the table cell marked "Any"
    Then the cell marked "tricyclic" should be unchecked
    Then I wait for 1 seconds
  When I touch the button marked "Inspect"
    Then I should see a "1 response" label
    