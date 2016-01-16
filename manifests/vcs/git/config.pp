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
    identity   => "${deployment_key_location}${name}_deployment_key",
    provider   => git,
    require    => File["${deployment_key_location}${name}_deployment_key"],
    revision   => 'test',
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

  # Set up a cron job to periodically pull
  cron { "cronjob_${name}":
    command => "eval $(ssh-agent); ssh-add ${deployment_key_location}${name}_deployment_key; cd ${path}; git pull origin test:test; chown -R ${owner}:${group} ${path}; chown -R ${owner}:${group} ${path}/.git; ssh-agent -k",
    hour    => '*',
    minute  => '*/10',
    require => [Vcsrepo["${path}"], File["${path}"], File["${path}/.git"]],
    user    => 'root',
  }
}
