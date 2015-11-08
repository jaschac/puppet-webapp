# The services managed by webapp
class webapp::service(
){

  # Manage language service
  case $::webapp::language {
    'django', 'python' : { notice("Python still not supported.") }
    'php' : { contain ::webapp::languages::php::service }
    'ror', 'ruby', 'ruby on rails' : { notice("Ruby on Rails still not supported.") }
    default: { notice("${$::webapp::language} not supported.") }
  }
  
}
