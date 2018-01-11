require "./version"
require "./url_service"
require "kemal"

Kemal.config.env = "production"

basename = ENV["BASENAME"]? || "http://localhost:3000"
redis_url = ENV["REDIS_URL"]? || "redis://localhost:6379/1"

UrlService.configure(redis_url, basename)

get "/version" do
  Server::VERSION
end

post "/url" do |env|
  original_url = env.params.body["url"].as(String)
  unless original_url
    env.response.status_code = 422
    next %({"error": "Missing url parameter"})
  end

  service = UrlService.new(original_url)
  short_url = service.short_url

  env.response.status_code = 201
  short_url
end

get "/:endpoint" do |env|
  endpoint = env.params.url["endpoint"]
  service = UrlService.new(endpoint)
  original_url = service.get

  unless original_url
    env.response.status_code = 404
    next %({"error": "There are no such page"})
  end
  
  env.redirect original_url
end

Kemal.run
