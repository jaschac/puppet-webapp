# Install anything under the direct control of Webapps
class webapps::install
()
{

  # Loop over web apps
  $::webapps::apps.each|$webapp_name, $webapp_config|{

    # VCS: remote repository SSH key deployment
    $deployment_key = try_get_value($::webapps::secrets, "${webapp_name}/vcs/deployment_key")
    if !empty($deployment_key){
      File{ "${webapp_name}_deployment_key":
        content => $deployment_key,
        group   => $webapp_config['owner']['group'],
        mode    => '0600',
        owner   => $webapp_config['owner']['name'],
        path    => "${webapp_config['vcs']['deployment_key_path']}/${webapp_name}_deployment_key",
      }
    }

    # VCS: clone the remote repository
    vcsrepo { "${webapp_config['vcs']['path']['local']}":
      ensure   => latest,
      group    => $webapp_config['owner']['group'],
      identity => "${webapp_config['vcs']['deployment_key_path']}/${webapp_name}_deployment_key",
      provider => $webapp_config['vcs']['engine'],
      require  => File["${webapp_name}_deployment_key"],
      revision => 'master',
      source   => $webapp_config['vcs']['path']['remote'],
      user     => $webapp_config['owner']['name'],
    }

    # Ensure the web application belongs to owner:group
    file { "${webapp_config['vcs']['path']['local']}":
      ensure  => directory,
      group   => "${webapp_config['owner']['group']}",
      owner   => "${webapp_config['owner']['name']}",
      recurse => true,
      require => Vcsrepo["${webapp_config['vcs']['path']['local']}"],
    }

    # Add the cron job
    cron { "cronjob_${webapp_name}":
      command => "eval $(ssh-agent); ssh-add ${webapp_config['vcs']['deployment_key_path']}/${webapp_name}_deployment_key; cd ${webapp_config['vcs']['path']['local']}; git pull origin master:master; chown -R ${webapp_config['owner']['name']}:${webapp_config['owner']['group']} ${webapp_config['vcs']['path']['local']}; ssh-agent -k",
    hour    => '*',
    minute  => '*/1',
    require => [Vcsrepo["${webapp_config['vcs']['path']['local']}"], File["${webapp_config['vcs']['path']['local']}"]],
    user    => 'root'
    }

  }

}
