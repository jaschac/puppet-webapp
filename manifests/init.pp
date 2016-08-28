# Defines a web application
class webapps
  (
  ) inherits ::webapps::params {
    contain ::webapps::install
    contain ::webapps::config
    contain ::webapps::service
  }
