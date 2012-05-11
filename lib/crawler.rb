require 'rubygems'
require 'nokogiri'
require 'mechanize'

class Spider

  
  # Define class variables and accessor methods
  @@initial_urls = Array.new
  @@visited = Array.new
  attr_accessor :host, :maxurls, :agent
  
  
  def get_visited
    return @@visited
  end
  
  
  def initialize(host, maxurls=nil)
    # when instance is instantiated define host value, maxurls if provided and build a new Mechanize agent object
    self.host = host
    self.agent = Mechanize.new
    self.agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    self.maxurls = maxurls
  end
  
  
  def crawl!(dif_page=nil)
    # This method can take a specific page, otherwise it grabs the self.host and starts the crawl process
    # The get_links method is called by this method which builds the initial list of URLs to start crawling
    page = self.agent.get(self.host) if !dif_page
    get_links(page)
    @@initial_urls.each do |url|
      Thread.new {
        # This loop digs deaper into the initial links and finds more
        # by calling the get_links method
        page = self.agent.get(url)
        get_links(page)
      }
    end
  end
  
  
  def get_links(page)
    puts "[.] Crawling..."
    page.links.each do |link|
      # This loops starts clicking on every link found
      begin
        # It won't click on links that it's already visited or links with broken uris like '#'
        unless self.agent.visited?(link) || link.uri.to_s == '#'
          link.click
          # After a link has been followed it's added to the visited array
          @@visited << link.uri.to_s
          puts "[.] Found: #{link.uri.to_s}"
        end
      rescue
        next
      end
    end
  end
  
  
  def generate_sitemap
    # After the crawler is finished with the page it passes the urls to this method
    # Which will generate a Sitemap of the target site
    puts "[.] Processed #{self.get_visited.length} links.\r\n"
    puts "[.] Generateing new Sitemap...\r\n"
    sitemap = Sitemap.new(@@visited)
    #return sitemap
    return "This is a Sitemap"
  end
  
  
end


class Sitemap
  # This is where we will define the code used to generate a working
  # sitemap of the specified target
end