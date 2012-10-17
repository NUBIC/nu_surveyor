Feature:
  As an user
  I want to take the mustache survey
  So I can tell you about my facial hair in a survey with custom substituted text in questions and answers

  Scenario:
    Mustache styles
  Given I launch the app using iOS 5.1 and the ipad simulator
  Given the device is in portrait orientation
  And I touch the button marked "Inspect"
  And I touch the button marked "loadMustache"
  And I wait for .5 seconds
  Then I should see "What does Jake wear these days?"
  And I should see "The imperial Northwestern"
  And I should see "How would Jake score these styles?"
  And I should see "The Northwestern horseshoe: 1-5 (1 best)"
  And I should see "The Northwestern lampshade: 1.0-9.9 (9.9 best)"
  And I should see "The Northwestern pencil: comment"
  And I should see "Where and when did Jake change their mustache style?"
  And I should see "At Northwestern, today, at"
  And I should see "At Northwestern, on this day"
  And I should see "At Northwestern, at this time on this day"
  And I should see "What would Jake wear in the future?"
  And I should see "The Northwestern walrus"
  And I should see "How many does Jake see?"
  And I should see "The Northwestern horseshoe, today"
  And I should see "The Northwestern lampshade, on average"
  And I should see "The Northwestern pencil, qualitatively"
  And I should see "Where and when does Jake trim their mustache?"
  When I scroll to the bottom of the table
  Then I should see "At Northwestern, daily, at"
  And I should see "At Northwestern, last on this day"
  And I should see "At Northwestern, last at this time on this day"
  And I should see "What is the best kind of facial hair for Jake?"
  And I should see "The Northwestern (null) of course"
  And I should see "Why did you choose this for Jake?"
  And I should see "Given the realities of Northwestern, I believe"
