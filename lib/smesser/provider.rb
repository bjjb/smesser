require 'mechanize'
require 'smesser'

module Smesser
  class Provider
    class << self
      attr_accessor :description
    end

    attr_accessor :username, :password

    def self.paths
      @paths ||= [File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'providers'))]
    end

    def self.load_all
      Smesser.log.debug("Loading all provider files in #{paths.inspect}")
      paths.each do |path|
        Dir["#{path}/*.rb"].each do |f|
          require f
        end
      end
    end

    def initialize(username, password)
      @username = username
      @password = password
    end

    def get(address)
      log.debug("Getting #{address}")
      agent.get(address) unless agent.page and agent.page.uri == URI.parse(address)
      log.debug("Got #{address} (#{page.code})")
      page.code
    end

    def post_form(spec, &block)
      spec = { :name => spec } if spec.is_a? String
      log.debug("Looking for form with #{spec.inspect}")
      form = page.form_with(spec)
      raise "Form not found: #{spec.inspect} on #{page.uri} (forms: #{page.forms.map(&:name).inspect})" unless form
      yield form
      log.debug("Submitting form: #{form.action} #{form.request_data}")
      form.submit
      log.debug("Submitted #{form.action} (#{page.code})")
      page.code
    end

    def click(spec)
      spec = { :text => spec } if spec.is_a? String
      log.debug("Looking for a form with #{spec.inspect}")
      link = page.link_with(spec)
      raise "Link not found: #{spec.inspect} on #{page.uri} (links: #{page.links.map(&:text).inspect})" unless link
      log.debug("Clicking link #{link.text} => #{link.href}")
      link.click
      log.debug("Clicked link #{link.href} (#{page.code})")
      page.code
    end

    def login
      raise "You need to override #{this}#login"
    end

    def send(message, *recipients)
      raise "You need to override #{this}#send"
    end

    def agent
      @agent ||= Mechanize.new
    end

    def page
      agent.page
    end

    def log
      Smesser.log
    end

    def logged_in?
      false
    end

  end
end
