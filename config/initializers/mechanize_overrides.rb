
#Patch Mechanize::Page with methods we can use to get assets and links
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