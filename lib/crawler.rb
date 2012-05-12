require 'rubygems'
require 'nokogiri'
require 'mechanize'

class Spider
  
  # Define class variables and accessor methods
  @@initial_urls = Array.new
  @@visited = Array.new
  attr_accessor :host, :maxurls, :agent, :domain, :visited
    
  def get_visited
    return @@visited
  end
  
  def initialize(host, maxurls=nil)
    # when instance is instantiated define host value, maxurls if provided and build a new Mechanize agent object
    self.visited = Array.new
    self.host = host
    self.domain = self.host.split(".")[1] + "." + self.host.split(".")[2]
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
    generate_sitemap(@@visited)
  end
    
  def get_links(page)
    puts "[.] Crawling..."
    page.links.each do |link|
      # This loops starts clicking on every link found
      begin
        # It won't click on links that it's already visited or links with broken uris like '#'
        unless self.visited.include?(link.uri.to_s) || link.uri.to_s == '#' 
          if isclean(link)
            # After a link has been followed it's added to the visited array
            @@visited << link.uri.to_s
            add_link(link)
          end
        end
      rescue
        next
      end
    end
  end
    
  def add_link(link)
    puts "[.] Found: #{link.uri.to_s}"
    self.visited << link.uri.to_s
  end
  
  def isclean(link)
    # Check to make sure link doesn't point to a website other then the specified target
    if link.uri.to_s.include?(".") && !link.uri.to_s.include?(self.domain)
      return false
    else
      return true
    end
  end
    
  def generate_sitemap(vlinks)
    # After the crawler is finished with the page it passes the urls to this method
    # Which will generate a Sitemap of the target site
    puts "[.] Processed #{vlinks.length} links.\r\n"
    puts "[.] Generateing new Sitemap...\r\n"
    sitemap = Sitemap.new(vlinks)
    #return sitemap
    return "This is a Sitemap"
  end
    
end


class Sitemap
  # This is where we will define the code used to generate a working
  # sitemap of the specified target
end