# Controls PHP related services
class webapp::languages::php::service(
) inherits ::webapp::languages::php::params
{

  $language_services.each |$service,$service_configuration|{
    Service{ $service:
      enable  => $service_configuration['enable'],
      ensure  => $service_configuration['ensure'],
      require => $service_configuration['require'],
    }
  }

}
