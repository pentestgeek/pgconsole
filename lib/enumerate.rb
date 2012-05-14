class Target

  attr_accessor :domain, :http_methods, :agent, :headers, :output, :top

  def initialize(domain)
    self.domain = domain
    self.top = self.domain.split(".")[1] + "." + self.domain.split(".")[2]
    self.agent = Mechanize.new
  end

  def enumerate!
    self.headers = get_headers(self.domain)
    get_methods(self.top)
    puts display_output
    nmap_enum(self.top)
  end
  
  def display_output
    self.output = "------------------------\r\n"
    self.output += "[+] Target:\r\n"
    self.output += "------------------------\r\n"
    self.output += self.domain.to_s + "\r\n\r\n"
    self.output += "------------------------\r\n"
    self.output += "[+] Allowed Methods:\r\n"
    self.output += "------------------------\r\n"
    self.output += self.http_methods.to_s + "\r\n\r\n"
    self.output += "------------------------\r\n"
    self.output += "[+] Headers:\r\n"
    self.output += "------------------------\r\n"
    self.output += self.headers + "\r\n"
    return self.output
  end

  def get_headers(domain)
    # Grab the HTTP response headers from the target URL
    headers = ""
    request = self.agent.get(domain)
    request.response.each_pair do |pair|
      # Cleans them up and displayes them in a readble output
      headers += pair[0].to_s + ": " + pair[1].to_s + "\r\n"
    end
    return headers  
  end
  
  def nmap_enum(host)
    # This method runs 'nmap -sT -sV -p 80,443,8080 example.com'
    puts "------------------------\r\n"
    puts "[+] Nmap:\r\n"
    puts "------------------------"
    Nmap::Program.scan do |nmap|
        nmap.verbose = false
        nmap.targets = host
        nmap.ports = [80,443,8080]
        nmap.connect_scan = true
        nmap.service_scan = true
    end
  end

  def get_methods(host)
    output = ""
    con = TCPSocket.open(self.top, 80)
    con.write("OPTIONS / HTTP/1.0\r\n\r\n")
      while resp = con.gets
        output += resp
      end
    con.close
    if output.include?("200 OK")
      output.split("\r\n").each do |line|
        if line.include?("Allow")
          self.http_methods = line
        end
      end
    else
      self.http_methods = "Could not retrieve HTTP Methods..."
    end
  end
  
end