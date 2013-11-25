gitstatus
=========

This gives the following report of the git repos of the organisation.
	1) Total commits within selected date
	2) Total commits by individual user within selected date
	3) Total commit by repo wises within selected date
	
Installation: Make sure you have ruby and octokit installed on your system. To install octokit use the following command in terminal
	$gem install octokit
	
Usage: After the requirements is fulfiled use the following command to get the report
	$ruby statistics.rb [start_date] [end_date]
		Date format: yyyy-mm-dd (eg. 2013-01-01)
		Note: To get commit for a day use same date in both start and end dates
