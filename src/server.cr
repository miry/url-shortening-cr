require "./version"
require "./url_service"
require "kemal"
require "redis"
require "pool/connection"

Kemal.config.env = "production"

basename = ENV["BASENAME"]? || "http://localhost:3000"
redis_url = ENV["REDIS_URL"]? || "redis://localhost:6379/1"

# Storage connections
redis_poll = ConnectionPool.new(capacity: 25, timeout: 0.01) do
  Redis.new(url: redis_url)
end

UrlService.configure(basename)

get "/version" do
  Server::VERSION
end

post "/url" do |env|
  original_url = env.params.body["url"].as(String)
  unless original_url
    env.response.status_code = 422
    next %({"error": "Missing url parameter"})
  end

  short_url = ""
  redis_poll.connection do |conn|
    service = UrlService.new(conn, original_url)
    short_url = service.short_url
  end

  env.response.status_code = 201
  short_url
end

get "/:endpoint" do |env|
  endpoint = env.params.url["endpoint"]
  original_url = String?
  redis_poll.connection do |conn|
    service = UrlService.new(conn, endpoint)
    original_url = service.get
  end

  unless original_url
    env.response.status_code = 404
    next %({"error": "There are no such page"})
  end
  
  env.redirect original_url.as(String)
end

Kemal.run
