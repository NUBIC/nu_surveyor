Feature:
  As an user
  I want to take the shoe survey
  So I can test repeaters

  Scenario:
    A new row is added
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadShoes"
  And I wait for animations

  When I use the keyboard to fill in the textfield marked "NUNoneCell Brand (null) (null) textField" with "Puma"
  And I use the keyboard to fill in the textfield marked "NUNoneCell Type (null) (null) textField" with "Fancy"
  And I touch the button marked "+ add row"
  And I should see "2" labels marked "Shoe Brand?"
  And I should see "2" labels marked "Shoe Type?"

  Scenario:
    The add row button appears once
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadShoes"
  And I wait for animations

  Then I should see "1" buttons marked "+ add row"