# Heroku scheduler tasks
namespace :schedule do
  desc '15 minutes slack alert'
  task alert_15_mins: :environment do
    # Slack notifier message
    NotifySlack.call(message: ":clock2: Release branch going up in 15 minutes.")
  end

  desc 'Create a release branch and send Slack notification'
  task create_release_branch: :environment do
    CreateReleaseBranch.call
  end
end
