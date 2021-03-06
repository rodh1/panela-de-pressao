Feature: Enable voice call integration of campaign 
  In order to allow people to connect directly with their representatives
  As an admin
  I want to enable voice call integratino

  @omniauth_test
  Scenario: when I'm admin
    Given I'm logged in as admin
    When I'm in the new campaign page
    Then I should see "Plivo integration"

  @omniauth_test
  Scenario: when I own a campaign awaiting moderation
    Given I'm logged in
    When I'm in the new campaign page
    Then I should not see "Plivo integration"


    
  @omniauth_test @javascript @bitly
  Scenario: when I'm smart enough to successfully fill the new campaign form
    Given I'm logged in as admin
    And I'm in the new campaign page
    And I fill "O nome da minha campanha será" with "Evitar que desapareçam com a praça Nossa Senhora da Paz"
    And I fill "A situação que eu quero mudar com ela é" with "A praça é um patrimônio histórico e existem outras soluções para o metro que tomará o seu lugar."
    And I fill "A mensagem de email que eu quero enviar para os alvos é" with "A praça é um patrimônio histórico e existem outras soluções para o metro que tomará o seu lugar."
    And I fill "O texto que eu quero postar na página do Facebook dos alvos é" with "A praça é um patrimônio histórico e existem outras soluções para o metro que tomará o seu lugar."
    And I fill "A mensagem de 140 caracteres que eu quero postar no twitter dos alvos é" with "A praça é um patrimônio histórico e existem outras soluções para o metro que tomará o seu lugar."
    And I fill "Script que deve ser lido para quem liga" with "Script with"
    And I fill "Número que receberá as ligações" with "2197137471"
    And I attach an image to "Para a divulgação da minha campanha bombar, vou usar essa imagem"
    And I select "Educação" for "E trata do tema"
    When I press "Enviar campanha para moderação"
    Then I should be in the campaigns page
    And I should see "Aí! Recebemos a sua campanha. Em breve entraremos em contato para colocá-la no ar..."
    And an email called "Recebemos a sua campanha" should be sent
    And an email called "Campanha aguardando moderação" should be sent



  Scenario: One accepted campaign exists 
    Given there is a campaign called "Desarmamento Voluntário" accepted on "1/1/2012"
    And there is a target for this campaign    
    When I go to this campaign page
    Then I should see the campaigns' name
    Then I should see the campaigns' description 
    Then I should see the campaigns' image
    Then I should see "ligaremos para que você fale diretamente"



  

