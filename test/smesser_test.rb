require 'test/unit'
require 'smesser'
require File.expand_path(File.join(File.dirname(__FILE__), 'provider'))

class TestSmesser < Test::Unit::TestCase
  def setup
    @options = {
      :provider => "dummy",
      :username => "test",
      :password => "secret",
      :recipients => ["1234567890", "0987654321"],
      :message => "Hello, world!"
    }
  end

  def test_provider_paths
    assert Smesser::Provider.paths.include?(File.expand_path(File.join(File.dirname(__FILE__), '..', 'providers')))
  end

  def test_config_files
    assert Smesser.config_files.include?("/usr/local/etc/smesserrc")
    assert Smesser.config_files.include?("/etc/smesserrc")
    assert Smesser.config_files.include?("~/.smesserrc")
  end

  def test_multiple_recipients
    assert_nothing_raised do
      Smesser.send_message(@options.merge(:recipients => "1234567890"))
      Smesser.send_message(@options.merge(:recipients => ["1234567890"]))
    end
  end
  # TODO - loads more tests!
end
