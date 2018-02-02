class BranchReleaseOffSource
  include Interactor
  extend Memoist
  delegate :message, to: :context

  ACTIVE_DAYS = %(Monday Tuesday Wednesday Thursday)

  before do
    context.fail!(message: "Not a weekday.") unless ACTIVE_DAYS.include? Date.current.strftime("%A")
  end

  def call
    master_sha = github.repos.branch(branch: source_name).commit.sha
    new_branch_name = "release/#{Date.current.strftime("%Y-%m-%d")}"

    begin
      github.git_data.references.create ref: "refs/heads/#{new_branch_name}", sha: master_sha
      release_url = "https://github.com/SnapDocs/snapdocs/compare/#{destination_name}...#{new_branch_name}"
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

  def source_name
    ENV['SOURCE_BRANCH'] || 'master'
  end

  def destination_name
    ENV['DESTINATION_BRANCH'] || 'production'
  end

end
