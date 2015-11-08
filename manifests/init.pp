# Defines a web application
class webapp
  (
) inherits ::webapp::params {
  contain ::webapp::install
  contain ::webapp::service
  contain ::webapp::config
}
