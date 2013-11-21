require_relative 'auth'
require 'octokit'

from = ARGV[0]
to = ARGV[1]
if from and to
	auth = Auth.new
	client = Octokit::Client.new :access_token => auth.get_token
	#client = Octokit::Client.new :login => auth.get_username, :password => get_pass
	user = client.user
	user.login
	sum = 0
	client.repos.each do |repo|
		puts repo.name
		puts repo.owner.login
		commit_list =  client.commits_between("#{repo.owner.login}/#{repo.name}", from, to)
		commit_count = commit_list.count
		sum = sum + commit_count
		puts commit_count
		puts "-------------------------------------------"
	end
	puts "total commits =  #{sum}"
else
	puts "wrong arguements"
	puts "fourth.rb <<from date>> <<to date>>"
	puts "date format eg: 2013-11-20"
end 