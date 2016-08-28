# Configures web applications and their dependencies
class webapps::config(){

  # Loop over the web apps
  $::webapps::apps.each|$webapp_name, $webapp_config|{

    # Generate web app specific Nginx' vhost configuration file
    file { "/etc/nginx/sites-enabled/${webapp_name}.conf":
      ensure  => file,
      content => epp("webapps/vhost.${webapp_config['ws']['template']['name']}.epp", {'args' => $webapp_config['ws']['template']['args']}),
      tag     => 'nginx-config'
    }

    # Make sure Nginx' default is not in place
    file { '/etc/nginx/sites-available/default':
      ensure  => absent,
      require => File["/etc/nginx/sites-enabled/${webapp_name}.conf"],
      tag     => 'nginx-config'
    }

    # Notify Nginx of the changes
    File <| tag == 'nginx-config' |> ~> Service['nginx']

  }
}
