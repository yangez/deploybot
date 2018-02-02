class CreateReleaseBranch
  include Interactor::Organizer

  organize BranchReleaseOffSource, NotifySlack
end
