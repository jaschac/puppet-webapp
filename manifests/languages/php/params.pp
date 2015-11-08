# PHP parameters
class webapp::languages::php::params(
){
  $language_dependencies = { 
    php5       => 'apt',
    php5-curl  => 'apt',
    php5-fpm   => 'apt',
    php5-mysql => 'apt',
   } 
}
