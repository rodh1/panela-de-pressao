#coding: utf-8

class PokeMailer < ActionMailer::Base
  default from: "Panela de Pressão <contato@paneladepressao.org.br>"
  layout 'mailer'

  def poke(the_poke)
    headers "X-SMTPAPI" => "{ \"category\": [\"pdp\", \"poke\"] }"
    @poke = the_poke
    mail(
      :to => the_poke.campaign.targets.map{|t| "'#{t.influencer.name}' <#{t.influencer.email}>" if !t.influencer.email.blank? }.join(", "), 
      :subject => the_poke.campaign.name,
      :from => "\"#{the_poke.user.name}\" <#{the_poke.user.email}>"
    )
  end

  def thanks(the_poke)
    headers "X-SMTPAPI" => "{ \"category\": [\"pdp\", \"thanks_for_your_poke\"] }"
    @poke = the_poke
    mail(:to => @poke.user.email, :subject => "Valeu por apoiar a campanha: #{@poke.campaign.name}")
  end
end
