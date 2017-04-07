class NotifySlack
  include Interactor

  delegate :message, to: :context

  def call
    notifier.ping(message)
  end

  def notifier
    Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end
end
