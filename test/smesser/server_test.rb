require 'test/unit'
require 'smesser/server'

class TestServer < Test::Unit::TestCase
  def test_server_startup
    assert Smesser::Server
    assert_respond_to Smesser::Server, :call
  end
end
