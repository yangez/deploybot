# Heroku scheduler tasks
namespace :schedule do
  desc '15 minutes slack alert'
  task alert_15_mins: :environment do
    # Slack notifier message
  end

  desc 'Create a release branch and send Slack notification'
  task create_release_branch: :environment do
    return unless %(Monday Tuesday Wednesday Thursday).include? Date.current.strftime("%A")
    github = Github.new oauth_token: ENV['GITHUB_OAUTH_TOKEN'], org: 'snapdocs', user: 'snapdocs', repo: 'snapdocs'
    master_sha = github.repos.branch(branch: 'master').commit.sha
    new_branch = github.git_data.references.create ref: "refs/heads/release-#{Date.current.strftime("%Y-%m-%d")}", sha: master_sha
    
    # Slack notifier message
  end
end
