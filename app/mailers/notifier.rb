class Notifier < ActionMailer::Base
  default from: "akankshita009@gmail.com"

  def welcome(recipient)
    @account = recipient
    mail(to: recipient.email, subject: 'BlendWith Activation Notice')
  end

end
