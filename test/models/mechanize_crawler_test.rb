require "test/unit"
require 'mechanize'

#TODO: move this from here so that it initializes seperately.
class Mechanize::Page
  def get_assets
    # Begin by getting the css ...

    # Then get the JS ...

  end

  def get_links
    #We loop through all the links and return an array of unique absolute hrefs
    #Gets a unique list of intra-domain links from the page

    #TODO: only use valid URI's.  check on regex
    #TODO: only grab the ones on the domain
    #TODO: uniq the links

    #TODO: don't count anchor stuff as part of the list.
    #TODO: exclude self from the list

    links = []

    self.links.each do |link|
      links << (self.uri.merge link.uri).to_s if link.uri
    end

    links.uniq!

  end

end

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
    expected_assets = {
        css:
          ['https://www.joingrouper.com/assets/application-82224c93c060bf8eb8bf1bb2bfd1eee5.css'],
        js:
            [
              'https://use.typekit.com/ilp6fts.js',
              'https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js',
              'https://www.joingrouper.com/assets/application-08a1ec4e9dd3cd46ce88383742eb3a75.js'
            ]
    }


    agent = Mechanize.new
    assert agent.get('http://www.joingrouper.com').get_assets == expected_assets

  end

  def test_get_links
    expected_links = ["https://www.joingrouper.com/london",
                      "https://www.joingrouper.com/apply_for_membership?a=index",
                      "https://www.joingrouper.com/jobs?source=landing",
                      "https://www.joingrouper.com/log_in",
                      "https://www.joingrouper.com/press",
                      "https://www.joingrouper.com/team",
                      "https://www.joingrouper.com/jobs",
                      "https://www.joingrouper.com/faq",
                      "https://www.joingrouper.com/venues",
                      "https://www.joingrouper.com/pro_tips",
                      "https://www.joingrouper.com/groupergrams",
                      "http://texts.joingrouper.com",
                      "http://blog.joingrouper.com",
                      "https://www.joingrouper.com/terms",
                      "https://www.joingrouper.com/privacy",
                      ]

    agent = Mechanize.new
    links = agent.get('http://joingrouper.com').get_links

    assert links == expected_links
  end

end