class Target

  attr_accessor :domain, :http_methods, :web_arch, :host_os, :agent, :headers, :output

  def initialize(domain)
    self.domain = domain
    self.agent = Mechanize.new
  end

  def enumerate!
    self.headers = get_headers(self.domain)
    puts display_output
  end
  
  def display_output
    self.output = "Target:\r\n"
    self.output += "------------------------\r\n"
    self.output += self.domain.to_s + "\r\n\r\n"
    self.output += "Headers:\r\n"
    self.output += "------------------------\r\n"
    self.output += self.headers
    return self.output
  end

  def get_headers(domain)
    headers = ""
    request = self.agent.get(domain)
    request.response.each_pair do |pair|
      headers += pair[0].to_s + ": " + pair[1].to_s + "\r\n"
    end
    return headers  
  end

  def display_info
  end

end

