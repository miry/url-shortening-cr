require "./version"
require "kemal"

get "/version" do
  Server::VERSION
end

post "/url" do
  "http://localhost:3000/asdf"
end

get "/:short_url" do |env|
  env.redirect "https://google.com"
end

Kemal.run
