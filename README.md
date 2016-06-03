# lostinmalloc-webapp
#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
    * [What the Module Does](#what-the-module-does)
    * [What the Module Does Not](#what-the-module-does-not)
3. [Setup](#setup)
    * [Requirements](#requirements)
    * [Dependencies](#dependencies)
4. [Usage](#usage)
    * [Secrets](#secrets)
5. [Reference](#reference)
    * [Languages](#languages)
      * [PHP](#php)
    * [Version Control Systems](#languages)
    * [Web Servers](#languages)
      * [Nginx](#nginx)
6. [Limitations](#limitations)
    * [Supported Languages and Frameworks](#supported-languages-and-frameworks)
    * [Supported Web Servers](#supported-web-servers)
    * [Supported Version Control Systems](#supported-version-control-systems)
7. [Development](#development)
8. [Contact](#contact)

## Overview
`lostinmalloc-webapp` is responsible to **setup self-deploying web applications**. It does support both static (pure HTML/CSS) and dynamic (PHP, Python and Ruby on Rails) applications. `lostinmalloc-webapp` is distributed through the Apache License 2.0. Please do refer to the [LICENSE](https://github.com/jaschac/puppet-webapp/blob/master/LICENSE) for details. 

## Module Description
`lostinmalloc-webapp` allows to easily setup self-deploying web applications. It is not responsible to setup and maintain the components required to do so, but rather, to **orchestrate** them.

#### What the Module Does
 - Provide the web server with the configuration needed to serve the web application.
 - Create and initialize a local directory that mirrors the remote one hosting the code to deploy.
 - Deploy a cron job that periodically pulls from the `master` branch of the remote repository, updating the application itself to its latest version.
 - Orchestrate all the modules required to get the web application up and running.

#### What the Module Does Not
 - Install nor manage the web server used to serve a web application.
 - Handle the remote repository that hosts a web application's code. The remote is expected to exist and be available. An SSH deployment key must be provided to `lostinmalloc-webapp`.
 - Install nor configure any service required by the web application (database, cache, ...).

## Setup
In order to install `lostinmalloc-webapp`, run the following command:

```bash
$ sudo puppet module install lostinmalloc-webapp
```

#### Requirements
`lostinmalloc-webapp` requires:

  - **Puppet 4.x**
  - `hiera-yaml 2.0.8+`

#### Dependencies
`lostinmalloc-webapp` depends on the following modules:

  - `lostinmalloc-git 0.0.7+`
  - `lostinmalloc-nginx 1.0.1+`
  - `lostinmalloc-phpfpm 1.0.1+`
  - `lostinmalloc-users 0.2.3+`
  - `puppetlabs-stdlib 2.2.1+`
  - `puppetlabs-vcsrepo 1.3.2+`

## Usage
The `lostinmalloc-webapp` module does expect all the data from Hiera. Sensitive data must be provided through `hiera-eyaml`.

#### Secrets
The `lostinmalloc-webapp` module relies on [`hiera-eyaml`](https://github.com/TomPoulton/hiera-eyaml) to encrypt sensitive data, such as passwords and SSH private keys. Since `lostinmalloc-webapp` expects all data to be provided through Hiera, the user is expected to be able to properly install and configure Puppet so that is has both the `yaml` and the `eyaml` backends.

This is an example of how to configure `lostinmalloc-webapp` through `YAML` and `eYAML`.

```yaml
# hieradata/nodes/puppet.lostinmalloc.com.yaml
---
webapp::params::webapps:
  foo:
    language:
      engine: 'php'
      limits:
        max_size_post: '100M'
        max_size_upload: '100M'
    owner:
      group: 'www-data'
      name: 'www-data'
    vcs:
      deployment_key:
        location: '/home/www-data/.ssh/'
      engine: 'git'
      path: '/var/www/foo'
      source: 'git@bitbucket.org:username/project_name.git'
    ws: 
      engine: 'nginx'
      template: 'php-fpm'
      template_args:
        listen_port: '80'
        root_dir: '/var/www/foo/'
        server_name: '_'
```

```yaml
# hieradata/secrets.eyaml
---
webapp::params::secrets:
  foo:
    vcs:
      deployment_key: |
        -----BEGIN RSA PRIVATE KEY-----
        some_nice_key
        -----END RSA PRIVATE KEY-----
```

## Reference
Here are presented the different configuration options of `lostinmalloc-webapp`.

**YAML**

  - `owner`: a hash that provides information about who owns the web application we are installing.
    - `group`: the group the user belongs to.
    - `name`: the user that owns the web application. The **client must ensure** that the user exists.
  - `vcs`
    - `deployment_key`
      - `location`: the full PATH to the directory where the SSH private deployment key will be stored. The **client must ensure** that it exists.
    - `engine`: the type of VCS to use. At the moment, only Git is supported.
    - `path`: The full PATH where the repository will be cloned into. This directory will be owned by `owner:group`. The `.git` subdirectory can be assigned to a different user, if needed.
    - `source`: the repository to clone.

**eYAML**

  - `vcs`
    - `deployment_key`: the private deployment SSH key used by the web application to periodically pull the source to serve from a remote repository. This key will be deployed at an arbitrary location, decided by the client, with `0600` permission. Through `owner`, the client defines who owns this key. The client is responsible to make sure that both the owner and the path where the key is stored exist.

### Languages

#### PHP
Optionally, the client can change the upload limits. This is important if we plan to use some web application such as `WordPress`. Changing these limits results in the `php.ini` file to get the following entries modified:

  - `upload_max_filesize`
  - `post_max_size`

`lostinmalloc-webapp` checks for the presence of either of these parameters within the `PHP` block and, in case, updates the configuration file. `lostinmalloc-webapp` does not, anyway, validate the value assigned to them by the client.

Note that, in order for this to work, the web server must also be properly configured. For example, on `Nginx` we must set `client_max_body_size` in the HTTP block. As aforementioned, `lostinmalloc-webapp` is not responsible of the web server itself, so that the client must make sure that it is.

### Version Control Systems

### Web Servers

#### Nginx
As aforementioned stated, `lostinmalloc-webapp` is not responsible neither to setup nor to configure `Nginx`. That's a responsibility of the client. Among the many details that should be taken care of are the following:

  - The `default` virtual host configuration file that ships with `Nginx`, and which is usually found in `/etc/nginx/sites-enabled/` as a soft linf to `/etc/nginx/sites-available/default`, should be removed, since it is very likely going to match the incoming requests, shadowing our vhost files.
  - If the web application allows the upload of files, then the `client_max_body_size` parameter should be properly set.

## Limitations
This module has been developed and tested on the following setup(s):

  - Operating Systems:
    - Debian 7 Wheezy (3.2.68-1+deb7u3 x86_64)
    - Debian 8 Jessie (3.16.7-ckt11-1+deb8u3 x86_64)
  - Puppet
    - 4.2.1
  - Hiera
    - 3.0.1
  - Facter
    - 2.4.4
  - Ruby
    - 2.1.6p336

#### Supported Languages and Frameworks
The `lostinmalloc-webapp` supports the following languages and frameworks:

 - Python

#### Supported Web Servers
`lostinmalloc-webapp` supports the following web servers:

 - Nginx

#### Supported Version Control Systems
`lostinmalloc-webapp` supports the following version control systems:

 - Git

## Development
`lostinmalloc-webapp` is being actively developed. As functionality is added and tested, it will be cherry-picked into the master branch. This README file will be promptly updated as that happens.

## Contact
Therea re several ways to get in touch with me:

  - [Linkedin](https://es.linkedin.com/in/jaschacasadio)
  - [GitHub](https://github.com/jaschac/puppet-webapp)
  - [Puppet Forge](https://forge.puppetlabs.com/lostinmalloc)

Please do report any bug and suggest new features/improvements.

