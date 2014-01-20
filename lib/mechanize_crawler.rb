class MechanizeCrawl
  @@crawled = {}
  @@agent = Mechanize.new
  @@agent.ssl_version = :TLSv1
  @@agent.keep_alive = false
  @@agent.max_history = 1
  @@agent.agent.http.verify_mode =  OpenSSL::SSL::VERIFY_NONE
  @@agent.agent.http.retry_change_requests = true


  def self.crawl_url(url)
    #FUTURE: depth limits
    #FUTURE: threading or queueing to allow for speed
    return if @@crawled[url] #Don't crawl it if we already crawled iot

    page_crawl = {}
    begin
      page = @@agent.get(url)
    rescue Mechanize::ResponseCodeError => e
      puts "Crawling URL #{url}: Response Code Error:" + e.response_code
      return
    end

    @@crawled[url] = {links: page.get_links, assets: page.get_assets}
    puts "Crawling URL #{url}: Success"

    @@crawled[url][:links].each do |url|
      crawl_url(url)
    end

  end

  def self.domain_crawl(url)
    crawl_url(url)
    PP.pp @@crawled


  end

end