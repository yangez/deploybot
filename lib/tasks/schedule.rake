# Heroku scheduler tasks
namespace :schedule do
  desc '15 minutes slack alert'
  task alert_15_mins: :environment do
    return unless (Time.zone.parse("4:40pm")..Time.zone.parse("4:50pm")).cover? Time.current
    NotifySlack.call(message: ":clock2: Release branch going up in 15 minutes.")
  end

  desc 'Create a release branch and send Slack notification'
  task create_release_branch: :environment do
    result = CreateReleaseBranch.call
    label = result.success? ? "Success" : "Failed"
    Rails.logger.info "#{label}: #{result.message}"
  end
end
