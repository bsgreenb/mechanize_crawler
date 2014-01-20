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

      link_url = (self.uri.merge link).to_s



      next unless link_url.match(URI.regexp(['http', 'https'])) #needs to mathch uri regex


      next if link_url == self.uri.to_s # Don't consider self linking a thing.

      # Make sure it's on the same top-level domain
      begin
        domainatrix = Domainatrix.parse(link_url)
        next unless domainatrix && (domainatrix.domain + '.' + domainatrix.public_suffix) == 'joingrouper.com'
      rescue #skip over stuff Domainatrix can't partse
        next
      end


      links << link_url
    end

    return links.uniq

  end

end