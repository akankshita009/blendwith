class Notifier < ActionMailer::Base
  default from: "chirag@intelithub.com"

  def welcome(recipient)
    @account = recipient
    mail(to: recipient.email, subject: 'BlendWith Activation Notice')
  end

end
