class BranchReleaseOffMaster
  include Interactor
  extend Memoist
  delegate :message, to: :context

  ACTIVE_DAYS = %(Monday Tuesday Wednesday Thursday Friday)

  before do
    context.fail!(reason: :inactive_day) unless ACTIVE_DAYS.include? Date.current.strftime("%A")
  end

  def call
    master_sha = github.repos.branch(branch: 'master').commit.sha
    new_branch_name = "release-#{Date.current.strftime("%Y-%m-%d")}"

    begin
      github.git_data.references.create ref: "refs/heads/#{new_branch_name}", sha: master_sha
      release_url = "https://github.com/SnapDocs/snapdocs/compare/production...#{new_branch_name}"
      context.message = ":rocket: Release branch created: #{release_url}"
    rescue Github::Error::UnprocessableEntity
      context.message = "Attempted to create release branch `#{new_branch_name}`, but it already exists."
    end
  end

  protected

  def github
    Github.new oauth_token: ENV['GITHUB_OAUTH_TOKEN'], org: 'snapdocs', user: 'snapdocs', repo: 'snapdocs'
  end
  memoize :github

end
