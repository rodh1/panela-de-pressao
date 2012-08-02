# coding: utf-8
Given /^I'm in ([^"]*)$/ do |arg1|
  case arg1
  when "the campaigns page"
    visit campaigns_path
  when "the new campaign page"
    visit new_campaign_path
  when "the influencers page"
    visit influencers_path
  when "the new influencer page"
    visit new_influencer_path
  when "this campaign page"
    visit campaign_path(@campaign)
  when "this campaign editing page"
    visit edit_campaign_path(@campaign)
  else
    raise "I don't know #{arg1}"
  end
end

Given /^there is a campaign created by "(.*?)" with no partnership$/ do |arg1|
  @campaign = Campaign.make! :user => User.make!(:name => arg1), :accepted_at => Time.now
end

Given /^there is a campaign created by "(.*?)" with a partnership with "(.*?)"$/ do |arg1, arg2|
  @campaign = Campaign.make! :user => User.make!(:name => arg1), :accepted_at => Time.now, :organizations => [Organization.make!(:name => arg2)]
end

Given /^there is a campaign called "([^"]*)" accepted on "([^"]*)"$/ do |arg1, arg2|
  @campaign = Campaign.make! name: arg1, accepted_at: Date.parse(arg2)
end

Given /^there is a campaign called "(.*?)" with an organization "(.*?)" as supporter accepted on "(.*?)"$/ do |arg1, arg2, arg3|
  @organization = Organization.make! name: arg2
  @campaign = Campaign.make! name: arg1, accepted_at: Date.parse(arg3), organizations: [@organization]
end

Given /^there is (\d+) pokers for this campaign$/ do |arg1|
  @pokes = []
  arg1.to_i.times do 
    @pokes << Poke.make!(campaign: @campaign, user: User.make!)
  end
end

Given /^I should see an avatar from organization "(.*?)"$/ do |arg1|
  page.should have_xpath("//img[@title='#{arg1}']")
end


Given /^there is a campaign called "([^"]*)"$/ do |arg1|
  @campaign = Campaign.make! name: arg1, accepted_at: Time.now
end

Given /^there is a campaign called "([^"]*)" awaiting moderation$/ do |arg1|
  @campaign = Campaign.make! name: arg1, accepted_at: nil
end

Given /^I own a campaign called "([^"]*)" awaiting moderation$/ do |arg1|
  @campaign = Campaign.make! name: arg1, accepted_at: nil, :user => Authorization.find_by_uid("536687842").user
end

Given /^I own a campaign called "([^"]*)"$/ do |arg1|
  @campaign = Campaign.make! name: arg1, :user => Authorization.find_by_uid("536687842").user, :accepted_at => Time.now
end

Given /^there is 1 poker called "(.*?)" that poked (\d+) times$/ do |name, quant|
  @poker = User.make! name: name 
  quant.to_i.times do
    Poke.make! campaign: @campaign, user: @poker
  end
end

Given /^I fill "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  fill_in arg1, :with => arg2
end

Given /^I'm logged in$/ do
  visit "/auth/facebook"
end

Given /^I'm logged in with Meu Rio$/ do
  visit "/auth/meurio"
end

Given /^I've created an organization called "([^"]*)"$/ do |arg1|
  Organization.make! name: arg1.to_s, owner: Authorization.find_by_uid("536687842").user, accepted: true
end

Given /^I'm logged in as admin$/ do
  visit "/auth/facebook"
  Authorization.find_by_uid("536687842").user.update_attributes :admin => true
end

Given /^I attach an image to "([^"]*)"$/ do |arg1|
  if arg1 == "Imagem de campanha"
    attach_file arg1, File.dirname(__FILE__) + "/../support/campaign.png"
  elsif arg1 == "Avatar"
    attach_file arg1, File.dirname(__FILE__) + "/../support/influencer.jpg"
  end
end

Given /^I select "([^"]*)" for "([^"]*)"$/ do |arg1, arg2|
  select arg1, :from => arg2
end

Given /^there is a target for this campaign$/ do
  @target = Target.make! :campaign => @campaign
end

Given /^there is a target for this campaign called "(.*?)"$/ do |arg1|
  @target = Target.make! campaign: @campaign, influencer: Influencer.make!(name: arg1)
end


Given /^I have a Twitter authorization$/ do
  Authorization.make! :user => Authorization.find_by_uid("536687842").user, :provider => "twitter"
end

Given /^there is a target for this campaign without ([^"]*)$/ do |arg1|
  @target = Target.make! :campaign => @campaign, :influencer => Influencer.make!(:facebook => "") if arg1 == "Facebook"
  @target = Target.make! :campaign => @campaign, :influencer => Influencer.make!(:twitter => "") if arg1 == "Twitter"
end

Given /^there is a poker called "(.*?)"$/ do |arg1|
  @poke = Poke.make! :campaign => @campaign
end

Given /^I check "(.*?)"$/ do |arg1|
  check(arg1)
end

Then /^I should see "([^"]*)"$/ do |arg1|
  case arg1
  when "the poker avatar"
    page.should have_css("img[src='/assets/pic.png']")
  when "user[name]"
    page.should have_css('input[name="user[name]"]')
  when "user[email]"
    page.should have_css('input[name="user[email]"]')
  when "user[about_me]"
    page.should have_css('textarea[name="user[about_me]"]')
  else
    page.should have_content(arg1)
  end
end

When /^I go to ([^"]*)$/ do |arg1|
  step "I'm in #{arg1}"
end

When /^I press "([^"]*)"$/ do |arg1|
  click_button arg1
end

When /^I click "([^"]*)"$/ do |arg1|
  if arg1 == "Pressionar via email"
    page.execute_script("$('form:has(input[value=\"email\"])').submit();")
  elsif arg1 == "Pressionar via Facebook"
    page.execute_script("$('form:has(input[value=\"facebook\"])').submit();")
  elsif arg1 == "Pressionar via Twitter"
    page.execute_script("$('form:has(input[value=\"twitter\"])').submit();")
  elsif arg1 == "Entrar via Facebook"
    within("#facebox") do
      click_on arg1
    end
  else 
    click_link(arg1)
  end
end

When /^I click on the "(.*?)" avatar$/ do |arg1|
  find(:xpath, "//a[@title=\"#{arg1}\"]").click
end

Then /^I should see "([^"]*)" before "([^"]*)"$/ do |arg1, arg2|
  page.html.should match(/#{arg1}(.|\s)+#{arg2}/)
end

Then /^I should not see "([^"]*)"$/ do |arg1|
  case arg1
  when "the Twitter poke button"
    page.should_not have_button("Via Twitter")
  when "the accept campaign button"
    page.should_not have_button("Aceitar campanha")
  when "the create campaign button"
    page.should_not have_button("Enviar campanha para moderação")
  when "the edit campaign button"
    page.should_not have_link("Editar campanha")
  when "the email poke form"
    page.should_not have_css("form:has(input[value='email'])")
  when "the Facebook poke button"
    page.should_not have_css("form:has(input[value='facebook'])")
  when "user[email]"
    page.should_not have_css('input[name="user[email]"]')
  else
    page.should_not have_content(arg1)
  end
end

Then /^I should be in ([^"]*)$/ do |arg1|
  case arg1
  when "the campaigns page"
    page.current_path.should be_== campaigns_path
  when "this campaign page"
    page.current_path.should be_== campaign_path(@campaign)
  when "the new campaign page"
    page.current_path.should be_== new_campaign_path
  when "this influencer's edit page"
    page.current_path.should be_== edit_influencer_path(@influencer)
  when "this influencer page"
    page.current_path.should be_== influencer_path(@influencer)
  else
    raise "I don't know '#{arg1}'"
  end
end

Then /^I should see the campaigns' ([^"]*)$/ do |arg|
  case arg
  when "name"
    page.should have_content(@campaign.name)
  when "description"
    page.should have_content(@campaign.description)
  when "image"
    page.should have_xpath("//img[@src='#{@campaign.image.url}']")
  end  
end

Then /^an email should be sent$/ do
  sleep(1)
  ActionMailer::Base.deliveries.should_not be_empty
end

Then /^an email called "(.*?)" should be sent$/ do |arg1|
  sleep(1)
  ActionMailer::Base.deliveries.select{|d| d.subject == arg1}.should_not be_empty
end

Then /^no email called "(.*?)" should be sent$/ do |arg1|
  sleep(1)
  ActionMailer::Base.deliveries.select{|d| d.subject == arg1}.should be_empty
end

Then /^an email called "(.*?)" should be sent once$/ do |arg1|
  sleep(1)
  ActionMailer::Base.deliveries.select{|d| d.subject == arg1}.should have(1).email
end

Then /^no email should be sent$/ do
  ActionMailer::Base.deliveries.should be_empty
end

Then /^a ([^"]*) poke should be added to the target$/ do |arg1|
  @target.reload.pokes_by_email.should be_== 1 if arg1 == "email"
  @target.reload.pokes_by_facebook.should be_== 1 if arg1 == "facebook"
end

Then /^this campaign should be accepted$/ do
  @campaign.reload.should be_accepted
end


Then /^I should see a list of (\d+) recent pokers$/ do |arg1|
  page.should have_css("div.pokers ol li", count: arg1.to_i)
end

Then /^I should see a list with order "(.*?)", "(.*?)", "(.*?)"$/ do |arg1, arg2, arg3|
  page.should have_css("div.more_active_pokers", text: /#{arg1}.*#{arg2}.*#{arg3}/)
end

When /^I open my profile options$/ do
  page.execute_script("$('.options').show();")
end

Given /^I already poked this campaign$/ do
  Poke.make! :campaign => @campaign, :user => User.find_by_email("nicolas@engage.is")
end

Given /^there is an influencer called "(.*?)"$/ do |arg1|
  @influencer = Influencer.make!(:name => arg1)
end
