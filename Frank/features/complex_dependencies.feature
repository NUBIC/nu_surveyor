Feature:
  As an user
  I want to take the animals survey
  So I can test complicated dependencies

  Scenario:
    Animals
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadAnimals"
  And I wait for animations

  When I touch the table cell marked "NUOneCell Yes"
  And I should not see "Do you like animals?"
  And I should not see "Do you like anything?"

