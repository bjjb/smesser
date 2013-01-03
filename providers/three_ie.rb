require 'smesser/provider'

class ThreeIe < Smesser::Provider
  @@url = "https://webtexts.three.ie"

  def login
    get(@@url)
    post_form(:action => '/webtext/users/login') do |form|
      form['data[User][telephoneNo]'] = @username
      form['data[User][pin]'] = @password
    end
  end

  def send(message, *recipients)
    get(@@url)
    post_form(:action => '/webtext/messages/send') do |form|
      form['data[Message][message]'] = message
      form['data[Message][recipients_individual]'] = recipients.join(',')
    end
    !!page.at('#flashMessage.success')
  end
end
