# Heroku scheduler tasks
namespace :schedule do
  desc '15 minutes slack alert'
  task alert_15_mins: :environment do
    # Slack notifier message
    NotifySlack.call(message: ":clock2: Release branch going up in 15 minutes.")
  end

  desc 'Create a release branch and send Slack notification'
  task create_release_branch: :environment do
    return unless %(Monday Tuesday Wednesday Thursday).include? Date.current.strftime("%A")
    github = Github.new oauth_token: ENV['GITHUB_OAUTH_TOKEN'], org: 'snapdocs', user: 'snapdocs', repo: 'snapdocs'
    master_sha = github.repos.branch(branch: 'master').commit.sha
    new_branch_name = "release-#{Date.current.strftime("%Y-%m-%d")}"
    create_new_branch = github.git_data.references.create ref: "refs/heads/#{new_branch_name}", sha: master_sha

    # Github::Error::UnprocessableEntity

    # Slack notifier message
    release_url = "https://github.com/SnapDocs/snapdocs/compare/production...#{new_branch_name}"
    NotifySlack.call(message: ":rocket: Release branch created: #{release_url}")

  end
end
