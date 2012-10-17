Feature:
  As an user
  I want to take the sesame street survey
  So I can pass over injected responses using hidden questions and question groups

  Scenario:
    Sesame street
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadSesame"
  And I wait for .5 seconds
  Then I should see "AH AH AH AH AH!"
  And I should see "What is your favorite number?"
  And I should not see "What is your name?"
  And I should not see "Who are your friends?"