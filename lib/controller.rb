def console_loop
  # This is the main loop that will handle all the commands from the user
  # Like a command shell
  loop do
    print "pgconsole>"
    command = gets.chomp
    # User input is passed to the run_command method which handles launching specific modules
    output = run_command(command)
    break if output == :quit
  end
end

def run_command(command)
  # This is the method that handles user inpot from the main console
  # Whatever command is entered it handled by this case statement and passed
  # To its proper function
  case command
  when 'quit'
    return :quit
  when 'help'
    puts help
  when 'spider'
    launch_spider_module
  when 'enum'
    enum_webserver
  when 'hosts'
    Host.get_hosts
  else
    puts "[-] Invalid Option, try 'help'"
  end
end

def launch_spider_module
  print "[.] Target URL: "
  # Take in a URL from the user and spider it
  target = gets.chomp
  if clean_url(target)
    spider = Spider.new(target)
    spider.crawl!
    #new_sitemap = spider.generate_sitemap
  else
    puts "[-] Error: must provide an absolute URL 'http://www...'"
  end
  # Once finished build a sitemap
  Host.new(spider.domain, spider.visited)
end

def clean_url(url)
  # Check if a url is clean and can be processed by the 'Mechanise' gem
  if url.to_s.include?("http:\/\/www.")
    return true
  else
    return false
  end
end

def enum_webserver
  # This method is used to start the enumeration module
  print "[.] Enter URL to enumerate: "
  domain = gets.chomp
  if clean_url(domain)
    # Creates an instance of the Target class and starts enumerating it
    target = Target.new(domain)
    target.enumerate!
  else
    puts "[-] Error: must provide an absolute URL 'http://www...'"
  end  
end

def help
  # This is the help menu
  help_string = "\n\n  --Commands--"
  help_string += "\n\n"
  help_string += "help\t-\tDisplays this help screen\r\n"
  help_string += "spider\t-\tSpiders a specified target website\r\n"
  help_string += "enum\t-\tRuns web enumeration modules against a specified URL\n"
  help_string += "hosts\t-\tDisplay information about scanned hosts\n"
  help_string += "quit\t-\tExits the applicaiton\r\n"
  help_string += "\n"
  return help_string
end