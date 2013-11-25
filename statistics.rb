require 'octokit'
require 'date'
class Statistics
	
	#Authentcating the git api using the personal access token
	#To generate one https://github.com/settings/tokens/new
	def authenticate
		my_access_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"#add your personal access token here 
		$client = Octokit::Client.new :access_token => my_access_token
		check = $client.login rescue nil
		if check
			puts "Authenticated user: \"#{$client.login}\" "
		else
			puts "Invalid Token, please use another token"
			exit
		end
	end

	#set the user configurations for page limits
	def set_config
		$org_git_name = 'leapfrogtechnology'
		$client.per_page = 100
		$client.auto_paginate = true
	end

	#check if the date privided is valid or not
	def check_args
		unless ($start_date and $end_date)
			puts "Wrong Number of arguments"
			display_guide 	
		end
		check_date($start_date)
		check_date($end_date)
		if $end_date < $start_date
			a=$start_date
			$start_date = $end_date
			$end_date = a
		end
	end

	#check if the date is valid or not
	def check_date(date)
		begin
   			Date.parse(date)
		rescue
   			puts "Error: Wrong Date Format"
			display_guide
		end
		true
	end

	#core logic
	def calculate
		total_commit_count = 0
		committer_name = []
		$all_repo = Hash.new(0)
		$client.org_repos($org_git_name).each do |repo|
			repo_commit_count = 0
			print "Calculating commits for repo \"#{repo.name}\", Please wait"
			branch_list = $client.branches("#{repo.owner.login}/#{repo.name}")
			all_commit_list = []
			branch_list.each do |branch|
				print "."
				branch_commit_count = 0
				branch_name = branch.name
				if($start_date == $end_date)
					commit_list =  $client.commits_on("#{repo.owner.login}/#{repo.name}",$start_date,branch_name)
				else
					commit_list =  $client.commits_between("#{repo.owner.login}/#{repo.name}",$start_date,$end_date,branch_name)
				end
				all_commit_list << commit_list
			end
			all_commit_list = all_commit_list.flatten
			temp_commit_list = []
			temp_commit_hash = Hash.new(0)
			unless all_commit_list.empty?
				all_commit_list.each do |commit_lst|
					if commit_lst.committer
						make_committer_name = "#{commit_lst.committer.login} (#{commit_lst.commit.committer.name})"
					else
						make_committer_name = "\t (#{commit_lst.commit.committer.name})"
					end
					temp_commit_hash[commit_lst.sha] = make_committer_name
				end
			end
			unless temp_commit_hash.empty?
				temp_commit_hash.each do |key, value|
					committer_name << value
				end
			end

			repo_commit_count = temp_commit_hash.length
			$all_repo[repo.name] = repo_commit_count
			puts "\n\"#{repo.name}\" repo has \"#{repo_commit_count}\" commits\n\n"
			total_commit_count = total_commit_count + repo_commit_count
		end
		calculate_user_commit_count(committer_name)
		total_commit_count
	end

	#to count the commits done by each user
	def calculate_user_commit_count(commiter_name)
		commiter_name = commiter_name.sort
		$all_user = Hash.new(0)
		commiter_name.each { |name| $all_user[name] += 1}	
	end

	#The usage information
	def display_guide
		puts "Usage: $ ruby statistics.rb [start_date] [end_date]"
		puts "Date format: yyyy-mm-dd (eg. 2013-01-01)"
		puts "Note: To get commit for a day use same date in both start and end dates"
		exit
	end
end

stat = Statistics.new

#taking the arguement from the command line
$start_date = ARGV[0]
$end_date = ARGV[1]

stat.check_args
puts "Authentcating, Please wait..."
stat.authenticate
stat.set_config
total = stat.calculate
puts "==================================\nREPORT from #{$start_date} to #{$end_date}\n==================================\n\n"
puts "Total Commit = #{total}\n\n"
puts "----------------------------------\nRepo Name => Commit Count\n----------------------------------"
$all_repo.each do |repo_name, repo_commit_count|
	puts repo_name + "=>" + repo_commit_count.to_s
end
puts "\n----------------------------------\nUser Name => Commit Count\n----------------------------------"
$all_user.each do |username, commit_count|
	puts username + " => " + commit_count.to_s
end