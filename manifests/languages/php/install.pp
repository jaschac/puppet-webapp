# Install PHP dependencies
class webapp::languages::php::install(
) inherits ::webapp::languages::php::params
{

  $language_mandatory_dependencies.each |$dependency,$provider| {
    if !defined(Package[$dependency]){
      Package{ $dependency:
        ensure   => present,
        provider => $provider,
        tag      => 'language_dependency',
      }
    }
  }

}
