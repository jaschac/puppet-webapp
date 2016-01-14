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
        notice("Python not supported, yet.")
      }
      
      'ruby' : {
        notice("Ruby on Rails not supported, yet.")
      }
      
      default: {
        notice("${webapp_config['language']} not supported, yet.")
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
    
    # Apply VCS specific configuration
    case $webapp_config['vcs']['engine']{
    
      'git' : {
        ::webapp::vcs::git::config { $webapp_name:
          deployment_key_location => $webapp_config['vcs']['deployment_key']['location'],
          group                   => $webapp_config['owner']['group'],
          owner                   => $webapp_config['owner']['name'],
          path                    => $webapp_config['vcs']['path'],
          source                  => $webapp_config['vcs']['source']
        }
      }

      default: {
        notice("${webapp_config['vcs']} not supported, yet.")
      }

    }
  }
}
