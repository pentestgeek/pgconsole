require 'crawler.rb'

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
  case command
  when 'quit'
    return :quit
  when 'help'
    puts help
  when 'spider'
    launch_spider_module
  else
    puts "[-] Invalid Option, try 'help'"
  end
end


def launch_spider_module
  print "[.] Target URL:"
  # Take in a URL from the user and spider it
  target = gets.chomp
  if target.to_s.include?"http:\/\/www."
    spider = Spider.new(target)
    spider.crawl!
    new_sitemap = spider.generate_sitemap
  else
    puts "[-] Error: must provide an absolute URL 'http://www...'"
  end
  # Once finished build a sitemap
end


def help
  help_string = "\n\n  --Commands--"
  help_string += "\n\n"
  help_string += "help\t-\tDisplays this help screen\r\n"
  help_string += "spider\t-\tSpiders a specified target website\r\n"
  help_string += "quit\t-\tExits the applicaiton\r\n"
  help_string += "\n"
  return help_string
end