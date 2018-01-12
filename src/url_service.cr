require "redis"
require "random/secure"

class UrlService
  def initialize(@conn : Redis, @original_url : String)
  end

  def self.configure(basename : String)
    @@basename = basename
  end

  def short_url
    path = get || create
    "#{@@basename}/#{path}"
  end

  def get
    @conn.get(@original_url)
  end

  def create
    short_url = ""
    existing = 1
    
    while existing == 1
      short_url = Random::Secure.urlsafe_base64(6)
      existing = @conn.exists(short_url)
    end

    @conn.set(@original_url, short_url)
    @conn.set(short_url, @original_url)
  
    return short_url
  end
end
