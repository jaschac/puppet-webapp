# Manage the Nginx configuration specific of different backends
define webapp::ws::nginx::config(
  Struct[{
    template      => Enum['php-fpm'],
    template_args => Struct[{
      listen_port => String[1, default],
      root_dir    => String[1, default],
      server_name => String[1, default]
    }] 
  }] $ws
) 
{
  # Add the Nginx PHP-FPM configuration file
  # Requires the Nginx directories to be in place already
  file { "/etc/nginx/sites-enabled/${name}.conf":
    ensure  => file,
    content => epp('webapp/ws/nginx/vhost.php-fpm.epp', {'args' => $ws['template_args']}),
  }

}
