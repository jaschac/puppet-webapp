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


  }
}
