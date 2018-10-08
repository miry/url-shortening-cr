require "option_parser"

require "benchmark"
require "http/client"

host = "http://localhost:3000"

OptionParser.parse! do |parser|
  parser.banner = "Usage: benchmark <hostname>"
  parser.on("-u", "--upcase", "Upcases the salute") { upcase = true }
  parser.on("-t NAME", "--to=NAME", "Specifies the name to salute") { |name| destination = name }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

# n = 5000000
# Benchmark.bm do |x|
#   x.report("times:") { n.times do
#     a = "1"
#   end }
#   x.report("upto:") { 1.upto(n) do
#     a = "1"
#   end }
# end


response = HTTP::Client.get "http://www.example.com"
response.status_code      # => 200
response.body.lines.first # => "<!doctype html>"