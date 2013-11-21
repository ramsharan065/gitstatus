require_relative 'auth'
require 'octokit'

auth = Auth.new
client = Octokit::Client.new :access_token => auth.get_token
#client = Octokit::Client.new :login => auth.get_username, :password => get_pass
user = client.user
user.login
sum = 0
client.repos.each do |repo|
	puts repo.name
	puts repo.owner.login
	commit_list =  client.commits_before("#{repo.owner.login}/#{repo.name}", '2013-11-01')
	commit_count = commit_list.count
	sum = sum + commit_count
	puts commit_count
	puts "-------------------------------------------"
end
puts "total commits =  #{sum}" 