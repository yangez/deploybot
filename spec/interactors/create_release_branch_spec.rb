require 'rails_helper'

RSpec.describe CreateReleaseBranch do
  let(:interactor_stub) { double(success?: true) }

  before do
    allow(CreateReleaseBranch).to receive(:call).and_return(interactor_stub)
    allow(NotifySlack).to receive(:call).and_return(interactor_stub)
  end

  subject(:create_release_branch) { CreateReleaseBranch.call }

  it { is_expected.to be_success }

end
