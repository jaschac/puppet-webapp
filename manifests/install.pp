# Install the dependencies based on the language and VCS used
class webapp::install
  (
){

  $::webapp::webapps.each|$webapp_name, $webapp_config|{
    
    # Install language dependencies
    case $webapp_config['language']['engine'] {

      'html' : {
        notice("HTML still not supported.")
      }

      'php' : {
        contain ::webapp::languages::php::install
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

    # Install web server related dependencies
    case $webapp_config['ws']['engine']{
      default: {
        notice("${webapp_config['ws']['engine']} not supported, yet.")
      }
    }

    # Install extra dependencies
    if !empty($webapp_config['extra_dependencies']){
      $webapp_config['extra_dependencies'].each |$dependency,$provider| {
        if !defined(Package[$dependency]){
          Package{ $dependency:
            ensure   => present,
            provider => $provider,
            tag      => 'extra_dependency',
          }
        }
      }
    }

    # Install VCS related dependencies: remote repository SSH key deployment
    $deployment_key = try_get_value($::webapp::secrets, "${webapp_name}/vcs/deployment_key")
    if !empty($deployment_key) and !defined(File["/.${webapp_name}_deployment_key"]){
      File{ "/.${webapp_name}_deployment_key":
	content => $deployment_key,
        group   => $webapp_config['owner']['group'],
        mode    => '0600',
        owner   => $webapp_config['owner']['name'],
      }
    }

  }

}
