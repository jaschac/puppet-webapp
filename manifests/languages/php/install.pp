# Install PHP dependencies
class webapp::languages::php::install(
) inherits ::webapp::languages::php::params
{
  contain ::webapp::languages::php::service 
  $language_dependencies.each |$dependency,$provider| {
    if !defined(Package[$dependency]){
      Package{ $dependency:
        ensure   => present,
        provider => $provider,
        tag      => 'language_dependency',
      }
    }
  }

}
