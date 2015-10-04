# lostinmalloc-webapp
#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
    * [What the Module Does](#what-the-module-does)
    * [What the Module Does Not](#what-the-module-does-not)
3. [Development](#development)

## Overview
This module is responsible to setup self-deploying web applications. It does support both static (pure HTML/CSS) and dynamic (PHP, Python and Ruby on Rails) applications. It is distributed through the Apache License 2.0. Please do refer to the LICENSE for details.

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

## Development
The lostinmalloc-webapp module is being actively developed. As functionality is added and tested, it will be cherry-picked into the master branch. This README file will be promptly updated as t    hat happens. You can contact me through the official page of this module: https://github.com/jaschac/puppet-webapp. Please do report any bug and suggest new features/improvements.
