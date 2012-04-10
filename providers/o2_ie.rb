require 'smesser/provider'

class O2Ie < Smesser::Provider
  @@start_url = "http://www.o2online.ie/o2/"
  @@send_action = "http://messaging.o2online.ie/smscenter_send.osp"
  @@send_delay = 2

  self.description = "www.o2.ie (400 free texts per month)"

  def logged_in?
    get @@start_url
    !!page.link_with(:text => 'Logout of o2.ie')
  end

  def login
    get(@@start_url)
    click('Login to o2.ie')
    post_form('o2login_form') do |form|
      form["IDToken1"] = @username
      form["IDToken2"] = @password
    end
  end

  def send(message, *recipients)
    get_webtext_page
    post_form('form_WebtextSend') do |form|
      form["SMSTo"] = recipients.join(", ")
      form["SMSText"] = message
      form.action = @@send_action
      sleep(@@send_delay)
    end
  end

  def remaining
    get_webtext_page
    if span = page.at("#spn_WebtextFree")
      span.inner_text
    else
      nil
    end
  end

  def get_webtext_page
    login unless logged_in?
    get(@@start_url)
    click('Send a webtext')
    get(page.frames.first.href)
  end
end
Smesser.providers['o2.ie'] = O2Ie
