# SMeSser

For using your provider's WebText programatically.

## Installation

Add this line to your application's Gemfile:

    gem 'smesser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smesser

## Usage

Smesser is generally supposed to be used as part of a more useful application,
for sending (free!) SMSs.

It does, however, come with a little command-line application (`smesser`). Try
`smesser -h` when it's installed.

## Configuration

You can program Smesser programatically, but it will also
have a look for some configuration files, and determine the
username/password/provider from there. These config files are loaded, in order,
if they exist:

* /etc/smesserrc
* /usr/local/etc/smesserrc
* ~/.smesserrc

*HINT*: If you're a command-line type of person (which I presume yuo are, as
you're reading this), then add a "contacts" hash to your configuration file.
These can be used as aliases instead of phone number.

Here's a sample configuration file, which you'd keep as ~/.smesserrc

```yaml
provider: o2.ie
username: "0861234567" # <-- Ensure a string, or the leading 0 could vanish!
password: secret
contacts:
  mom: "+3538712345678"
  dad: "+1123456788"
  lisa: "08517171717"
```

## Providers

The core of Smesser is done by little [Mechanize][mechanize] agents, called
Providers, that know how to log in (as you) to a specific website, fill in a
form, and submit it.

The only requirements for a Provider is that it responds to `login` and `send`.
By subclassing Smesser::Provider, you get a couple of convenience methods to
help you create your own.

Have a look at bundled providers for info on how to write your own provider.

Currently, there's

* vodafone.ie
* o2.ie

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[mechanize]: http://mechanize.rubyforge.org/
