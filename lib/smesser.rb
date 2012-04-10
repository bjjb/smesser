require 'yaml'
require 'ostruct'
require 'logger'
require "smesser/version"

module Smesser
  autoload :Provider, 'smesser/provider'

  def self.config_files
    @configfiles ||= [
      "/etc/smesserrc",
      "/usr/local/etc/smesserrc",
      "~/.smesserrc"
    ]
  end

  # The easiest way to send an SMS.
  #
  # Accepts the following options:
  #
  # provider::    The name of the provider to use (see `providers`)
  # username::    The username to log in with
  # password::    The password to log in with
  # message::     The message
  # recipients::  An array of recipients. If Smesser has `contacts` configured,
  #               then you can use aliases here.
  # retry::       The number of times to attempt sending. Default is 1.
  #
  # If any are missing, Smesser's configuration will be checked for a suitable
  # value.
  #
  # Returns a hash, with (at least)
  #
  # status::    'OK' if all went well, 'Failed' otherwise
  #
  # ...and any additional provider specific return values. A common one might be
  # `:remaining`, to indicate the number of free SMSs left with the provider.
  def self.send_message(options = {})
    options.dup.each { |k, v| options[k.to_sym] = options.delete(k) if k.is_a?(String) }

    args = configuration.merge(options)
    log.debug("Sending message: args = #{args.inspect}")

    provider = providers[args[:provider]].new(args[:username], args[:password])
    log.debug("Provider: #{provider.inspect}")

    recipients = lookup_contacts(args[:recipients])
    log.debug("Recipients: #{recipients.inspect}")

    unless provider.logged_in?
      log.debug("Logging in... (#{args[:username]})")
      provider.login unless args[:dryrun]
    end

    log.info("Message: #{args[:message].inspect}")

    result = {}

    if args[:dryrun] or provider.send(args[:message], *recipients)
      log.info "Message sent."
      result[:code] = "OK"
      result[:remaining] = provider.remaining if provider.respond_to?(:remaining)
    elsif args[:retry] and args[:retry] > 0
      log.info "Failed, trying again... (#{args[:retry]})"
      args[:retry] -= 1
      return send_message(args)
    else
      log.info "Failed!"
      result[:code] = "Failed"
    end

    result
  end

  def self.log
    return @log if @log
    @log = Logger.new(STDOUT)
    @log.level = Logger::WARN
    @log
  end

  def self.configuration
    @configuration ||= load_config!
  end

  def self.providers
    Provider.load_all
    @providers ||= {}
  end

  def self.load_config!
    config = {}
    config_files.each do |f|
      if File.exists?(path = File.expand_path(f))
        config.merge!(YAML.load(File.read(path)))
      end
    end
    config.dup.each { |k, v| config[k.to_sym] = v if k.is_a?(String) }
    config
  end

  def self.lookup_contacts(recipients)
    contacts = configuration[:contacts]
    return recipients unless contacts
    recipients.map do |r|
      log.debug "#{r} => #{contacts[r]}" if contacts[r]
      contacts[r] || r
    end
  end

  def self.print_providers(io = STDOUT)
    providers.each do |k, v|
      io.puts "#{k}: #{v.description || 'No description'}"
    end
  end
end
