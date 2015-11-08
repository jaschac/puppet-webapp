# lostinmalloc-webapp
#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
    * [What the Module Does](#what-the-module-does)
    * [What the Module Does Not](#what-the-module-does-not)
    * [Supported Languages and Frameworks](#supported-languages-and-frameworks)
    * [Supported Web Servers](#supported-web-servers)
    * [Supported Version Control Systems](#supported-version-control-systems)
3. [Setup](#setup)
    * [Requirements](#requirements)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

## Overview
This module is responsible to setup self-deploying web applications. It does support both static (pure HTML/CSS) and dynamic (PHP, Python and Ruby on Rails) applications. It takes advantage of the many new features introduced by Puppet 4, so that it is not backwards compatible. lostinmalloc-webapp is distributed through the Apache License 2.0. Please do refer to the LICENSE for details. 

## Module Description

#### What the Module Does
 - The module does take care to provide a configuration file specific to the web server used to serve its content. If, for example, a web application is served through Nginx, then lostinmalloc-webapp will deploy, at an arbitrary location, a vhost configuration file compliant with Nginx.'s expectations.
 - The module does take care to notify the web server each time the configuration file of a web application is being touched.
 - The module does take care to create and initialize the local directory that mirrors the remote one hosting the code to deploy.
 - The modules does take care to install the dependencies required to run a web application, depending on its technology.
 - The module does take care to deploy a cron job that periodically pulls from the master branch of the remote repository, thus updating the application itself.

#### What the Module Does Not
 - The module does neither install nor manage the web server used to serve a web application. If, for example, a web application is to be served through Nginx, then the node must have a module that takes care of both its installation and general configuration (workers, ...).
 - The module does not handle the remote repository that hosts a web application's code. The remote is expected to exist and be available. An SSH deployment key must be provided to lostinmalloc-webapp to pull.
 - The module does not install nor configure any database used by the web application. It does expect the user that owns the web application to exist and have the proper permissions.

#### Supported Languages and Frameworks
The lostinmalloc-webapp supports the following languages and frameworks:

 - Pure HTML/CSS/Boostrap static websites
 - PHP
 - Python
 - Ruby on Rails

#### Supported Web Servers
The lostinmalloc-webapp supports the following web servers:

 - Apache
 - Nginx

#### Supported Version Control Systems
lostinmalloc-webapp supports the following version control systems:

 - Git
 - Mercurial
 - Subversion

## Setup
lostinmalloc-webapp can be installed in different ways.

#### Installing the module from the Puppet Forge

In order to install this module, run the following command:

```bash
    puppet module install lostinmalloc-webapp
```

#### Getting the source code from Git Hub

@TODO

#### Requirements

@TODO

## Usage
The lostinmalloc-webapp module does expect all the data from Hiera. Everything is retrieved through data binding.

@TODO

## Reference

@TODO


## Limitations

@TODO

## Development
The lostinmalloc-webapp module is being actively developed. As functionality is added and tested, it will be cherry-picked into the master branch. This README file will be promptly updated as that happens.

You can contact me through the official page of this module: https://github.com/jaschac/puppet-webapp. Please do report any bug and suggest new features/improvements.

This module has been developed and tested on the following setup(s):

  * *Operating Systems*:
    * Debian 7 Wheezy (3.2.68-1+deb7u3 x86_64)
    * Debian 8 Jessie (3.16.7-ckt11-1+deb8u3 x86_64)
  * *Puppet*
    * 4.2.1
  * *Hiera*
    * 3.0.1
  * *Facter*
    * 2.4.4
  * *Ruby*
    * 2.1.6p336
