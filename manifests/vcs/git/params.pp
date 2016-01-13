# Git parameters
class webapp::vcs::git::params(
){

  $vcs_mandatory_dependencies = {
    git => 'apt',
  }

}
