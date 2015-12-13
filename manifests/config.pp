# Language, VCS and Web Server configuration
class webapp::config(
){

  $::webapp::webapps.each|$webapp_name, $webapp_config|{

    # Apply  language specific configuration
    case $webapp_config['language']['engine'] {
      
      'php' : {
        ::webapp::languages::php::config { $webapp_name:
          limits => empty($webapp_config['language']['limits']) ? {
            false  => $webapp_config['language']['limits'],
            true   => {}
          }     
        }
      }

      'python' : { 
        notice("Python still not supported.")
      }
      
      'ruby' : {
        notice("Ruby on Rails still not supported.")
      }
      
      default: {
        notice("${webapp_config['language']} not supported.")
      }
    }

    # Apply web server specific configuration
    case $webapp_config['ws']['engine']{
    
      'nginx': {
        ::webapp::ws::nginx::config { $webapp_name:
          ws => {
            template      => $webapp_config['ws']['template'],
            template_args => $webapp_config['ws']['template_args']
          }
        }
      }

      default: {
        notice("${webapp_config['ws']['engine']} not supported, yet.")
      }
    }

  }
}
