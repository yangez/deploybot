require 'rails_helper'

RSpec.describe BranchReleaseOffSource do
  let(:github_stub) { double(Github) }
  before do
    allow(github_stub).to receive_message_chain('repos.branch.commit.sha').and_return("test_sha")
    allow(github_stub).to receive_message_chain('git_data.references.create')
    allow_any_instance_of(BranchReleaseOffSource).to receive(:github).and_return(github_stub)
  end

  subject(:branch_release_off_source) { BranchReleaseOffSource.call }

  it { is_expected.to be_success }

  it "has the correct message" do
    expect(branch_release_off_source.message).to include "Release branch created"
  end

  context "when it's the weekend" do
    before { Timecop.freeze(Date.new(2017, 4, 8)) } # Saturday
    after { Timecop.return }

    it { is_expected.to_not be_success }
  end

end
