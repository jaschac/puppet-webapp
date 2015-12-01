# Install the dependencies based on the language and VCS used
class webapp::install
  (
){

  $::webapp::webapps.each|$webapp_name, $webapp_config|{
    
    # Install language dependencies
    case $webapp_config['language'] {

      'django', 'python' : {
        notice("Python still not supported.")
      }

      'php' : {
        contain ::webapp::languages::php::install
      }

      'ror', 'ruby', 'ruby on rails' : {
        notice("Ruby on Rails still not supported.")
      }
      
      default: {
        notice("${webapp_config['language']} not supported.")
      }

    }

    # Install web server related dependencies
    case $webapp_config['ws']['engine']{
      default: {
        notice("${webapp_config['ws']['engine']} not supported, yet.")
      }
    }
  }

}
