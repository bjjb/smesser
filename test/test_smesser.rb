require 'test/unit'
require 'smesser'

class TestSmesser < Test::Unit::TestCase
  def test_provider_paths
    assert Smesser::Provider.paths.include?(File.expand_path(File.join(File.dirname(__FILE__), '..', 'providers')))
  end

  def test_config_files
    assert Smesser.config_files.include?("/usr/local/etc/smesserrc")
    assert Smesser.config_files.include?("/etc/smesserrc")
    assert Smesser.config_files.include?("~/.smesserrc")
  end

  # TODO - loads more tests!
end
