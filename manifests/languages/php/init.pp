#
class webapp::languages::php::init(
) inherits ::webapp::languages::php::params {
  contain ::webapp::languages::php::install
}
