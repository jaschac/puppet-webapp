# Language, VCS and Web Server configuration
class webapp::config(
){

  $::webapp::webapps.each|$webapp_name, $webapp_config|{

    # Apply  language specific configuration
    case $webapp_config['language'] {
      
      'django', 'python' : {
         notice("Python still not supported.")
       }
      
      'php' : {
         contain ::webapp::languages::php::config
       }
      
      'ror', 'ruby', 'ruby on rails' : {
        notice("Ruby on Rails still not supported.")
      }
      
      default: {
        notice("${webapp_config['language']} not supported.")
      }
    }

    # Apply web server specific configuration
    case $webapp_config['ws']['engine']{
    
      'nginx': {
        ::webapp::ws::nginx::config{webapp_name:
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
