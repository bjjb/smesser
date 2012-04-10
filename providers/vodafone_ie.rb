require 'smesser/provider'

class VodafoneIe < Smesser::Provider
  @@start_url = "https://www.vodafone.ie/myv/index.jsp"
  @@login_url = "https://www.vodafone.ie/myv/services/login/login.jsp"
  @@webtext_url = "https://www.vodafone.ie/myv/messaging/webtext/index.jsp"
  @@send_delay = 3 # Vodafone's servers don't like instantaneousness.

  self.description = "www.vodafone.ie"

  def logged_in?
    log.debug("Checking if logged in")
    get(@@start_url)
    if page.uri == URI.parse(@@start_url)
      log.debug("Logged in")
      true
    else
      log.debug("Not logged in")
      false
    end
  end

  def login
    get(@@login_url)
    post_form('Login') do |form|
      form.username = @username
      form.password = @password
    end
  end

  def send(message, *recipients)
    get(@@webtext_url)

    post_form('WebText') do |form|
      form.message = message
      recipients.each_with_index do |recipient, index|
        form["recipients[#{index}]"] = recipient
      end
      sleep(@@send_delay)
    end

    log.debug("Looking for div#webtext-thankyou")
    if !!page.at('div#webtext-thankyou')
      log.debug("Found!")
      true
    else
      log.warn("No matching element found!")
      false
    end
  end

  def remaining
    log.debug("Checking remaining texts...")
    login unless logged_in?
    get @@webtext_url unless page.uri == URI::parse(@@webtext_url)
    if div = page.at("div.info-row.text-remaining strong")
      log.debug("Found element")
      div.inner_text
    else
      log.warn("No matching element found!")
      nil
    end
  end
end
Smesser.providers['vodafone.ie'] = VodafoneIe
