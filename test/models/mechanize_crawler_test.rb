require "test/unit"

class MechanizeCrawlerTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_get_assets
    agent = Mechanize.new
    assets = agent.get('http://joingrouper.com').get_assets #TODO: fakeweb this
    assert assets == {write out this hash}

  end

  def test_get_links
    agent = Mechanize.new
    links = agent.get('http://joingrouper.com').get_link
    assert links == {write out this hash}
  end

end