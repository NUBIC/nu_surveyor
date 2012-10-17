Feature:
  As an user
  I want to take the complex responses survey
  So I can tell you about my medications

  Scenario:
    Medications Pick Any
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadComplexResponses"
  And I go to the "Any" section
  And I should see "Which pain medications are you taking (please list the names)"
  And I use the keyboard to fill in the textfield marked "NUAnyStringOrNumberCell NSAIDs (null) textField" with "Ibuprofen"
  And I touch the button marked "Inspect"
  Then I should see "1 response"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyStringOrNumberCell opioids (null) (null)"
  And I press done on the keyboard
  Then the 2nd cell should be checked
  And I touch the button marked "Inspect"
  Then I should see "2 responses"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyStringOrNumberCell NSAIDs Ibuprofen (null)"
  And I press done on the keyboard
  Then the 1st cell should be unchecked
  And I touch the button marked "Inspect"
  Then I should see "1 response"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyStringOrNumberCell NSAIDs (null) (null)"
  And I press done on the keyboard
  Then the 1st cell should be checked
  And I touch the button marked "Inspect"
  Then I should see "2 responses"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyDatePickerCell Took a sleeping pill"
  And I touch the button marked "Now"
  Then the 8th cell should be checked
  And I touch the button marked "Inspect"
  Then I should see "3 responses"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyDatePickerCell Woke up feeling refreshed"
  And I touch the button marked "Done"
  Then the 7th cell should be checked
  And I touch the button marked "Inspect"
  Then I should see "4 responses"

  When I navigate back
  And I touch the upper left of the table cell marked "NUAnyDatePickerCell Woke up today"
  And I touch the button marked "Cancel"
  Then the 6th cell should be checked
  And I touch the button marked "Inspect"
  Then I should see "5 responses"

  Scenario:
    Medications Pick One
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadComplexResponses"
  And I touch the button marked "Sections"
  When I touch the table cell marked "One"
  And I should see "When did you last take your medication?"
  And I touch the upper left of the table cell marked "NUOneDatePickerCell Today at"
  And I wait for .5 seconds
  And I touch the button marked "Now"
  Then the 1st cell should be dotted
  And I touch the button marked "Inspect"
  Then I should see "1 response"

  When I navigate back
  And I touch the upper left of the table cell marked "NUOneDatePickerCell On this very day"
  And I touch the button marked "Done"
  Then the 2nd cell should be dotted
  And the 1st cell should be undotted
  And I touch the button marked "Inspect"
  Then I should see "1 response"

  When I navigate back
  And I touch the upper left of the table cell marked "NUOneStringOrNumberCell I cannot tell you because (null) (null)"
  Then the 4th cell should be dotted
  And the 2nd cell should be undotted
  And I touch the button marked "Inspect"
  Then I should see "1 response"

  When I navigate back
  And I touch the upper left of the table cell marked "NUOneStringOrNumberCell I cannot tell you because (null) (null)"
  Then the 4th cell should be dotted
  And I touch the upper left of the table cell marked "NUOneDatePickerCell On this day, at"
  And I touch the button marked "Cancel"
  And I touch the button marked "Inspect"
  Then I should see "1 response"
