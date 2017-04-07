class CreateReleaseBranch
  include Interactor::Organizer

  organize BranchReleaseOffMaster, NotifySlack
end
