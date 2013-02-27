Feature:
  As an user
  I want to take the dependency toolbox survey
  So I can test multiple dependencies

  Scenario:
  Given I launch the app using iOS 6.0 and the ipad simulator
  When I touch the button marked "Inspect"
    And I touch the button marked "loadTextFieldMask"
    Then I wait for 1 seconds
  When I SLOWLY use the keyboard to fill in the textfield marked "(___) ___-____" with "12ed34a567sde8fs90" without hitting done
    Then I should really see "(123) 456-7890" in the textfield marked "NUNoneCell numeric (null) (null) textField"
  When I SLOWLY use the keyboard to fill in the textfield marked "???????" with "12ab34c567def8g90" without hitting done
    Then I should really see "abcdefg" in the textfield marked "NUNoneCell alpha (null) (null) textField"
  When I SLOWLY use the keyboard to fill in the textfield marked "YYDDM_" with "12ab34c567def8g90" without hitting done
    Then I should really see "12ab34" in the textfield marked "NUNoneCell any (null) (null) textField"


