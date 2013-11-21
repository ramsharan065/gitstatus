#require 'open-uri'
#contents = open('http://www.example.com') {|io| io.read}
# or
#contents = URI.parse('https://api.github.com/users/ojash').read
require 'net/http'
require 'json'

url = 'https://api.github.com/users/leapfrogtechnology'
uri = URI(url)
request = Net::HTTP::Get.new(uri.path)
request['669cabb1e9ccffd48b41152b5235cd3f9a93a522'] = 'x-oauth-basic'
response = Net::HTTP.new(uri.host,uri.port) do |http|
  http.request(request)
end
#contents = Net::HTTP.get(URI.parse(url))
#my_hash = JSON.parse(contents)
my_hash = JSON.parse(response.to_s)
#my_hash.each do |first, second|
#	puts first.to_s + " => " + second.to_s
#end
repos = Net::HTTP.get(URI.parse(my_hash['repos_url']))
repos_t_hash = JSON.parse(repos)
repos_t_hash.each do |repo|
	repo.each do |first, second|
		puts first.to_s + " => " + second.to_s
	end
	puts "-------------------------------------------------------"
end
#puts contents