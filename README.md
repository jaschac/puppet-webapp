# lostinmalloc-webapp
#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
    * [What the Module Does](#what-the-module-does)
    * [What the Module Does Not](#what-the-module-does-not)
3. [Setup](#setup)
    * [Requirements](#requirements)
    * [Secrets](#secrets)
4. [Usage](#usage)
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
`lostinmalloc-webapp` is responsible to **setup self-deploying web applications**. It does support both static (pure HTML/CSS) and dynamic (PHP, Python and Ruby on Rails) applications. It takes advantage of the many new features introduced by Puppet 4, so that it is not backwards compatible. `lostinmalloc-webapp` is distributed through the Apache License 2.0. Please do refer to the LICENSE for details. 

## Module Description
@TODO

#### What the Module Does
 - The module does take care to provide a configuration file specific to the web server used to serve its content. If, for example, a web application is served through Nginx, then lostinmalloc-webapp will deploy, at an arbitrary location, a vhost configuration file compliant with Nginx.'s expectations.
 - The module does take care to notify the web server each time the configuration file of a web application is being touched.
 - The module does take care to create and initialize the local directory that mirrors the remote one hosting the code to deploy.
 - The modules does take care to install the dependencies required to run a web application, depending on its technology.
 - The module does take care to deploy a cron job that periodically pulls from the master branch of the remote repository, thus updating the application itself.

#### What the Module Does Not
 - The module does neither install nor manage the web server used to serve a web application. If, for example, a web application is to be served through Nginx, then the node must have a module that takes care of both its installation and general configuration (workers, ...).
   - In the case of Nginx, for example, it is responsibility of the client to make sure that Apache is not running. The Apache webserver, which is a dependency of PHP-FPM, for example, does bind, by default, to port 80 and is automatically started, so that in the case of a PHP-FPM web application deployed on Nginx, the client should take care of this.
 - The module does not handle the remote repository that hosts a web application's code. The remote is expected to exist and be available. An SSH deployment key must be provided to lostinmalloc-webapp to pull.
 - The module does not install nor configure any database used by the web application. It does expect the user that owns the web application to exist and have the proper permissions.

## Setup
`lostinmalloc-webapp` can be installed in different ways.

#### Installing the module from the Puppet Forge
In order to install this module, run the following command:

```bash
    puppet module install lostinmalloc-webapp
```

#### Getting the source code from Git Hub
@TODO

#### Secrets
The `lostinmalloc-webapp` module relies on [`hiera-eyaml`](https://github.com/TomPoulton/hiera-eyaml) to encrypt sensitive data, such as passwords and SSH private keys. Since `lostinmalloc-webapp` expects all data to be provided through Hiera, the user is expected to be able to properly install and configure Puppet so that is has both the `yaml` and the `eyaml` backends.

#### Requirements
The `lostinmalloc-webapp` module requires:

  - **Puppet** 4.0+
  - `hiera-yaml` 2.0.8+

## Usage
The `lostinmalloc-webapp` module does expect all the data from Hiera. Since part of the information is sensitive, part of if must be given through `hiera-eyaml`.

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

 - Pure HTML/CSS/Boostrap static websites
 - PHP
 - Python
 - Ruby on Rails

#### Supported Web Servers
The `lostinmalloc-webapp` supports the following web servers:

 - Apache
 - Nginx

#### Supported Version Control Systems
`lostinmalloc-webapp` supports the following version control systems:

 - Git
 - Mercurial
 - Subversion

## Development
The `lostinmalloc-webapp`` module is being actively developed. As functionality is added and tested, it will be cherry-picked into the master branch. This README file will be promptly updated as that happens.

## Contact
Therea re several ways to get in touch with me:

  - [Linkedin](https://es.linkedin.com/in/jaschacasadio)
  - [GitHub](https://github.com/jaschac/puppet-webapp)
  - [Puppet Forge](https://forge.puppetlabs.com/lostinmalloc)

Please do report any bug and suggest new features/improvements.
