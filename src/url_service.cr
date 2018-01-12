require "redis"
require "random/secure"
require "pool/connection"
class UrlService
  def initialize(@original_url : String)
  end

  def self.configure(redis_url : String, basename : String)
    @@redis_url = redis_url
    self.redis
    @@basename = basename
  end

  def self.redis
    @@redis ||= ConnectionPool.new(capacity: 25, timeout: 0.01) do
      Redis.new(url: @@redis_url)
    end
  end

  def short_url
    path = get || create
    "#{@@basename}/#{path}"
  end

  def get
    self.class.redis.get(@original_url)
  end

  def create
    short_url = ""
    existing = 1
    self.class.redis.connection do |redis|
      while existing == 1
        short_url = Random::Secure.urlsafe_base64(6)
        existing = redis.exists(short_url)
      end

      redis.set(@original_url, short_url)
      redis.set(short_url, @original_url)
    end
    return short_url
  end
end
