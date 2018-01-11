require "redis"
require "random/secure"

class UrlService
  def initialize(@original_url : String)
  end

  def self.configure(redis_url : String, basename : String)
    @@redis = Redis.new(url: redis_url)
    @@basename = basename
  end

  def self.redis
    @@redis || Redis.new
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
    redis = self.class.redis
    while existing == 1
      short_url = Random::Secure.urlsafe_base64(6)
      existing = redis.exists(short_url)
    end

    redis.set(@original_url, short_url)
    redis.set(short_url, @original_url)

    return short_url
  end
end
