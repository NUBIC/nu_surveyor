Feature: 
  As an user
  I want to take the complex responses survey
  So I can tell you about my medications

  Scenario: 
    Medications
  Given I launch the app using iOS 5.0 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadComplexResponses"
  And I touch the button marked "Sections"
  When I touch the table cell marked "Any"
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