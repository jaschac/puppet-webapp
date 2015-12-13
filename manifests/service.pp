# The services managed by webapp
class webapp::service(
){

  $::webapp::webapps.each|$webapp_name, $webapp_config|{
  
    # Manage language service
    case $webapp_config['language']['engine'] {

      'django', 'python': {
        notice("Python still not supported.")
      }

      'php': {
        contain ::webapp::languages::php::service
      }

      'ror', 'ruby', 'ruby on rails': {
        notice("Ruby on Rails still not supported.")
      }

      default: {
        notice("${webapp_config['language']} not supported.")
      }

    }


    # Manage web server service
    case $webapp_config['ws']['engine'] {
      
      'nginx': {
        contain ::webapp::ws::nginx::service
      }

      default: {
        notice("${webapp_config['ws']['engine']} not supported, yet.")
      }

    }


  }
  
}
