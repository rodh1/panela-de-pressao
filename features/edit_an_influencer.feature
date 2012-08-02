Feature: edit an influencer
  In order to help to keep influencer's data up to date
  As a visitor
  I want to edit an influencer

  @omniauth_test
  Scenario: when I submit the form with no error
    Given there is an influencer called "Eduardo Paes"
    And I'm logged in as admin
    And I'm in the influencers page
    When I click "Eduardo Paes"
    Then I should be in this influencer page
    Given I fill "Email" with "eduardera@meurio.org.br"
    When I press "Salvar influenciador"
    Then I should be in this influencer page
    And I should see "eduardera@meurio.org.br"
