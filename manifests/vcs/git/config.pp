# Configure Git specific parameters
define webapp::vcs::git::config(
  String[1, default] $deployment_key_location,
  String[1, default] $group,
  String[1, default] $owner,
  String[1, default] $path,
  String[1, default] $source
)
{

  # Clone the remote repository
  vcsrepo { "${path}":
    ensure     => latest,
    group      => "${group}",
    identity   => '/home/www-data/.ssh/foo_deployment_key',
    provider   => git,
    require    => File["${deployment_key_location}${name}_deployment_key"],
    source     => "${source}",
    user       => "${owner}",
  }

  # Ensure the directory belongs to the owner:group
  file { "${path}":
      ensure  => directory,
      group   => "${group}",
      owner   => "${owner}",
      recurse => true,
      require => Vcsrepo["${path}"],
    }

  # Ensure the .git directory belonts to owner:group
  # If this is different, pass the data in
  file { "${path}/.git":
    ensure  => directory,
    group   => "${group}",
    owner   => "${owner}",
    recurse => true,
    require => [Vcsrepo["${path}"], File["${path}"]],
  }

}
