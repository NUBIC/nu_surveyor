Feature:
  As an user
  I want to take the translation survey
  So I can test translations for questions, answers, titles

  Background:
    Given I launch the app using iOS 6.0 and the ipad simulator
    And the device is in landscape orientation
    And I wait for animations
    And I touch the button marked "Inspect"
    And I touch the button marked "loadTranslations"
    And I wait for animations

  Scenario: 
    Translating questions and answer
      Given I touch the button marked "Language"
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      Then I should see "Este es un ejemplo de una pregunta con la traducción"

  Scenario: 
    Translating by showing hidden answer and then translate
      When I touch the table cell marked "Python"
        Then I wait for 1 seconds
        Then I should see "Please explain why you don't like this programming language"      
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
        Then I should see "Por favor, explique por qué no te gusta este lenguaje de programación"

    Scenario: 
    Translating by translating then showing hidden answer
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      When I touch the table cell marked "Python"
        Then I wait for 1 seconds
        Then I should see "Por favor, explique por qué no te gusta este lenguaje de programación"
      Given I touch the button marked "Language"
      When I touch "English"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
        Then I should see "Please explain why you don't like this programming language"  

    Scenario: 
    Translations across sections
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      When I touch "Sección Secundaria"
        Then I should see "Esto es para asegurarse de que otras secciones se comportan"  

    Scenario: 
    Translations across sections keeps persistent
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      When I touch "Sección Secundaria"
        Then I should see "Esto es para asegurarse de que otras secciones se comportan"
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Français"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
        Then I should see "Question avec traduction"
      When I touch "Question avec traduction"
        Then I should see "Ceci est un exemple d'une question à la traduction"  

      Scenario:
      Translation with repeater function
      Given I touch "Repeater"
        And I wait for 1 seconds
      Given I touch the button marked "Language"
        And I wait for 1 seconds
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
        Then I should see "Rojo"
        When I touch the table cell marked "Rojo"
          And  I wait for animations
        When I touch the button marked "+ sumar la fila"
          And  I wait for animations
          And  touch the 2nd table cell marked "Verde"
          And  I wait for animations
          Then I should see a "Usted gana!!" label

      Scenario:
      Translation Question / Answer UUID consistent
      When I touch the table cell marked "red"
        And I wait for animations
      And I touch the button marked "Inspect"
        And I touch the button marked "loadTranslations"
        And I wait for animations
      Given I touch the button marked "Language"
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      When I touch the table cell marked "rojo"
        And I wait for animations
      And I touch the button marked "Inspect"
        Then I should see that label with index 2 should match text of index with tag 5
        Then I should see that label with index 3 should match text of index with tag 6
    
      Scenario:
      Translation Question / Answer UUID not misfiring
      When I touch the table cell marked "red"
        And I wait for animations
      And I touch the button marked "Inspect"
        And I touch the button marked "loadTranslations"
        And I wait for animations
      Given I touch the button marked "Language"
      When I touch "Espanol"
        And I wait for 1 seconds
      When I touch in Done
        And I wait for 1 seconds
      When I touch the table cell marked "azul"
        And I wait for animations
      And I touch the button marked "Inspect"
        Then I should see that label with index 2 should match text of index with tag 5
        Then I should see that label with index 3 should NOT match text of index with tag 6






