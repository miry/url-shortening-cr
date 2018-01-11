require "./version"
require "./url_service"
require "kemal"

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
    %({"error": "Missing url parameter"})
  end

  service = UrlService.new(original_url)
  short_url = service.short_url

  env.response.status_code = 201
  short_url
end

get "/:short_url" do |env|
  short_url = env.params.url["short_url"]
  env.redirect "https://www.google.de/search?&q=" + short_url
end

Kemal.run
