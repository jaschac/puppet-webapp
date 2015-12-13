# Configure PHP specific parameters
define webapp::languages::php::config(
  Optional[
    Struct[{
      max_size_post   => Optional[String[1, default]],
      max_size_upload => Optional[String[1, default]]
    }]
  ] $limits
)
{
  file { '/etc/php5/fpm/php.ini':
    ensure  => file,
    content => epp('webapp/languages/php/php.ini.epp', {'limits' => $limits})
  } 

}
