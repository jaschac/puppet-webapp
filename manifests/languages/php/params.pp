# PHP parameters
class webapp::languages::php::params(
){
  
  $language_dependencies = { 
    php5       => 'apt',
    php5-curl  => 'apt',
    php5-fpm   => 'apt',
    php5-mysql => 'apt',
  } 
  
  $language_services = {
    php5-fpm   => {
      ensure  => running,
      enable  => true,
      require => Package['php5-fpm'],
    },
  }
}
