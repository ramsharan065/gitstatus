require_relative 'auth'
require 'octokit'

auth = Auth.new
client = Octokit::Client.new :access_token => auth.get_token
user = client.user
user.login


client.repos.each do |repo|
    puts repo.name
    #puts repo.description

    # find the urls
    #puts repo.rels[:html].href
    #puts repo.rels[:git].href
    #puts repo.rels[:clone].href
    #puts repo.rels[:ssh].href
end