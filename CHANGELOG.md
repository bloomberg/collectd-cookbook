# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## 2.2.2
### Bug Fixes
- Service not restarting on package update.

## 2.2.1
### Bug Fixes
- [PR#1] - Fix provider for installing from source on Ubuntu.

## 2.2
### Features
- PR#7 Adds custom resource for managing template plugin files.

## 2.1.2
### Bug Fixes
- PR#6 Fix errors with multiple value configurations.

## 2.1.1
### Bug Fixes
- PR#5 Use upgrade action on Solaris platform.

## 2.1
### Features
- PR#4 Support for Solaris 11 platform.

## 2.0
### Major Features
- Adds custom resources for managing service and configuration separately.
- Uses [Poise][1] and [Poise Service][0] libraries to provide platform independence.

[0]: https://github.com/poise/poise-service
[1]: https://github.com/poise/poise
[PR#1]: https://github.com/bloomberg/collectd-cookbook/pull/1
