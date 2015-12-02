# Controls Nginx related servuces
class webapp::ws::nginx::service(
) inherits ::webapp::ws::nginx::params
{
  exec { 'reload nginx':
    command => $osfamily ? {
      'Debian' => '/usr/sbin/service nginx restart',
      default  => "${$osfamily} not supported.",
      }
    }
}
