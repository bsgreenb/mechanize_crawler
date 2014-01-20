require "test/unit"
require 'mechanize'
require 'domainatrix'

#TODO: move this from here so that it initializes seperately.
class Mechanize::Page
  def get_assets
    # Begin by getting the css ...
    css = []
    self.search('link[@href]').each do |link_tag| # loop through <link> tags with an href attribute
      link_url = (self.uri.merge link_tag[:href]).to_s
      next unless link_url.match(URI.regexp(['http', 'https'])) #needs to mathch uri regex
      next unless link_url.match(/.+\.css$/)

      css << link_url
    end
    css.uniq!

    # Then get the JS ...
    js = []
    self.search('script[@src]').each do |script_tag| # loop through <script> tags with a src attribute
      script_url = (self.uri.merge script_tag[:src]).to_s
      next unless script_url.match(URI.regexp(['http', 'https']))
      js << script_url
    end
    js.uniq!

    return {css: css, js: js}

  end

  def get_links
    #We loop through all the links and return an array of unique absolute hrefs
    #Gets a unique list of intra-domain links from the page

    links = []

    self.links.each do |link|
      link = link.uri

      # Make sure it has a valid link url...
      next if !link #needs a uri


      # get rid of the anchor fragment, it could cause us trouble..
      link.fragment = nil

      if link.host #If it has a host it's more than just a path url
        # Make sure it's on the same top-level domain

        domainatrix = Domainatrix.parse(link.host)
        next unless domainatrix && (domainatrix.domain + '.' + domainatrix.public_suffix) == 'joingrouper.com'
      end

      link_url = (self.uri.merge link).to_s

      next unless link_url.match(URI.regexp(['http', 'https'])) #needs to mathch uri regex

      next if link_url == self.uri.to_s # Don't consider self linking a thing.

      links << link_url
    end

    return links.uniq

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
              'https://cdn.optimizely.com/js/279869788.js',
              'https://use.typekit.com/ilp6fts.js',
              'https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js',
              'https://www.joingrouper.com/assets/application-08a1ec4e9dd3cd46ce88383742eb3a75.js'
            ]
    }


    agent = Mechanize.new
    assets = agent.get('http://www.joingrouper.com').get_assets

    assert assets == expected_assets, "#{assets} don't match expected_assets"

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

    assert links == expected_links, "#{links.inspect} don't match expected_links"
  end

end