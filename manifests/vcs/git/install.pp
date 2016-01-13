# Install Git dependencies
class webapp::vcs::git::install(
) inherits ::webapp::vcs::git::params
{

  $vcs_mandatory_dependencies.each |$dependency,$provider| {
    if !defined(Package[$dependency]){
      Package{ $dependency:
        ensure   => present,
        provider => $provider,
        tag      => 'vcs_dependency',
      }
    }
  }

}
