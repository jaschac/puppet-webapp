# Language, VCS and Web Server configuration
class webapp::config(
){

  # Apply  nguage specific configuration
  case $::webapp::language {
    'django', 'python' : { notice("Python still not supported.") }
    'php' : { contain ::webapp::languages::php::config }
    'ror', 'ruby', 'ruby on rails' : { notice("Ruby on Rails still not supported.") }
    default: { notice("${$::webapp::language} not supported.") }
  }
}
