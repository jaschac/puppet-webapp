# Install the dependencies based on the language and VCS used
class webapp::install
  (
){

  # Install language dependencies
  case $::webapp::language {
    'django', 'python' : { notice("Python still not supported.") }
    'php' : { contain ::webapp::languages::php::install }
    'ror', 'ruby', 'ruby on rails' : { notice("Ruby on Rails still not supported.") }
    default: { notice("${$::webapp::language} not supported.") }
  }

}
