require 'octokit'
client = Octokit::Client.new :access_token => "669cabb1e9ccffd48b41152b5235cd3f9a93a522"
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