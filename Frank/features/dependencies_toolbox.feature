Feature:
  As an user
  I want to take the dependency toolbox survey
  So I can test multiple dependencies

  Scenario:
  Given I launch the app using iOS 5.1 and the ipad simulator
    And the device is in landscape orientation
    Then I wait for 2 seconds
  When I touch the button marked "Inspect"
    And I touch the button marked "loadDependencyToolbox"
    Then I wait for 1 seconds
  When I touch the table cell marked "YES"
    Then I should see "YES GROUP"
    Then I wait for 1 seconds
  When I touch the table cell marked "NO"
    Then I should see "NO GROUP"
    Then I wait for 1 seconds
  When I touch the table cell marked "YES"
    Then I should see "YES GROUP"
    Then I wait for 1 seconds
  When I touch the table cell marked "COMMUTING"
    Then I should see "COMMUTING"
    Then I wait for 1 seconds
  When I touch the table cell marked "ONE"
    Then I should see "DEPENDENCY A"
    Then I wait for 1 seconds
  When I touch the table cell marked "ONE"
    Then I wait for 1 seconds
  When I touch the table cell marked "FOUR"
    Then I should see "HERE IS DEPENDENCY B"
    Then I should see "HERE IS DEPENDENCY A THAT SHOWS WITH B"
    Then I wait for 1 seconds
  When I touch the table cell marked "FOUR"
    Then I wait for 1 seconds
    

  
