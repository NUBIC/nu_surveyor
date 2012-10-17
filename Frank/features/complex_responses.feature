Feature:
  As an user
  I want to take the complex responses survey
  So I can tell you about my medications

  Scenario:
    Medications Pick Any
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I touch the button marked "Inspect"
    And I touch the button marked "loadComplexResponses"
    And I go to the "Any" section
  Then I should see "Which pain medications are you taking (please list the names)"

  When I use the keyboard to fill in the textfield marked "NUAnyStringOrNumberCell NSAIDs (null) textField" with "Ibuprofen"
  Then there should be 1 response

  When I touch the upper left of the table cell marked "NUAnyStringOrNumberCell opioids (null) (null)"
    And I press done on the keyboard
  Then the cell marked "NUAnyStringOrNumberCell opioids" should be checked
    And there should be 2 responses

  When I touch the upper left of the table cell marked "NUAnyStringOrNumberCell NSAIDs Ibuprofen (null)"
    And I press done on the keyboard
  Then the cell marked "NUAnyStringOrNumberCell NSAIDs (null) (null)" should be unchecked
    And there should be 1 response

  When I touch the upper left of the table cell marked "NUAnyStringOrNumberCell NSAIDs (null) (null)"
    And I press done on the keyboard
  Then the cell marked "NUAnyStringOrNumberCell NSAIDs" should be checked
    And there should be 2 responses

  When I touch the upper left of the table cell marked "NUAnyDatePickerCell Took a sleeping pill"
    And I touch the button marked "Now"
  Then the cell marked "NUAnyDatePickerCell Took a sleeping pill" should be checked
    And there should be 3 responses

  When I touch the upper left of the table cell marked "NUAnyDatePickerCell Woke up feeling refreshed"
    And I touch the button marked "Done"
  Then the cell marked "NUAnyDatePickerCell Woke up feeling refreshed" should be checked
    And there should be 4 responses

  When I touch the upper left of the table cell marked "NUAnyDatePickerCell Woke up today"
    And I touch the button marked "Cancel"
  Then the cell marked "NUAnyDatePickerCell Woke up today" should be checked
    And there should be 5 responses

  Scenario:
    Medications Pick One
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in portrait orientation
  When I touch the button marked "Inspect"
    And I touch the button marked "loadComplexResponses"
    And I go to the "One" section
  Then I should see "When did you last take your medication?"

  When I touch the upper left of the table cell marked "NUOneDatePickerCell Today at"
    And I wait for animations
    And I touch the button marked "Now"
  Then the cell marked "NUOneDatePickerCell Today at" should be dotted
    And there should be 1 response

  When I touch the upper left of the table cell marked "NUOneDatePickerCell On this very day"
    And I touch the button marked "Done"
  Then the cell marked "NUOneDatePickerCell On this very day" should be dotted
    And the cell marked "NUOneDatePickerCell Today at" should be undotted
    And there should be 1 response

  When I touch the upper left of the table cell marked "NUOneStringOrNumberCell I cannot tell you because (null) (null)"
    And I press done on the keyboard
  Then the cell marked "NUOneStringOrNumberCell I cannot tell you because" should be dotted
    And the cell marked "NUOneDatePickerCell On this very day" should be undotted
    And there should be 1 response

  When I touch the upper left of the table cell marked "NUOneStringOrNumberCell I cannot tell you because (null) (null)"
  Then the cell marked "NUOneStringOrNumberCell I cannot tell you because" should be dotted

  When I touch the upper left of the table cell marked "NUOneDatePickerCell On this day, at"
    And I touch the button marked "Cancel"
  Then there should be 1 response
