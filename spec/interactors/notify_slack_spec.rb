require 'rails_helper'

RSpec.describe NotifySlack do
  before do
    allow_any_instance_of(NotifySlack).to receive(:notifier).and_return(double(Slack::Notifier, ping: true))
  end

  subject(:notify_slack) { NotifySlack.call(message: 'Hello') }

  it { is_expected.to be_success }
end
