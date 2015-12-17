# collectd-cookbook
[![Build Status](https://img.shields.io/travis/bloomberg/collectd-cookbook.svg)](https://travis-ci.org/bloomberg/collectd-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/bloomberg/collectd-cookbook.svg)](https://codeclimate.com/github/bloomberg/collectd-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/collectd.svg)](https://supermarket.chef.io/cookbooks/collectd)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] which installs and configures the
[collectd monitoring daemon][1].

This cookbook provides a dead-simple installation and configuration of
the collectd monitoring daemon. It provides two resources: the first
is for managing the collectd system service, and the second is for
configuring the daemon's plugins. Additionally, the
[collectd_plugins cookbook][4] may be used to configure many of the
common plugins that ship with the daemon.

It is very important to note that distributions may ship different
major versions of the package, but the following platforms are tested
using the integration tests via [Test Kitchen][2].
- Ubuntu ~> 10.04, 12.04, 14.04
- CentOS ~> 5.8, 6.4, 7.1
- RHEL ~> 5.8, 6.4, 7.1

## Basic Usage
The [default recipe](recipes/default.rb) in this cookbook simply
configures the monitoring daemon to run as a system service. The
configuration for this service can be tuned using the
[node attributes](attributes/default.rb). Additionally, a resource is
provided to configure plugins for the daemon. After a plugin has been
configured the daemon should be restarted.

### Enabling Syslog
One of the simplest plugins to enable is the [collectd Syslog plugin][3]
which receives log messages from the daemon and dispatches them to the
to syslog. This allows the daemon's logs to easily integrate with
existing UNIX utilities.
```ruby
collectd_plugin 'syslog' do
  options do
    log_level 'info'
    notify_level 'OKAY'
  end
end
```

## Advanced Usage
In order to enable the full functionality of some of the more
intrusive collectd plugins the daemon will need to run as the root
user. Since this is obviously a security risk it is not the default.
To achieve this behavior you're required to write a
[wrapper cookbook][5] which overrides the service user with the proper
root user.
```ruby
node.default['collectd']['service_user'] = node['root_user']
node.default['collectd']['service_group'] = node['root_group']
include_recipe 'collectd::default'
```

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern#theapplicationcookbook
[1]: https://collectd.org
[2]: https://github.com/test-kitchen/test-kitchen
[3]: https://collectd.org/wiki/index.php/Plugin:SysLog
[4]: https://github.com/bloomberg/collectd_plugins-cookbook
[5]: http://blog.vialstudios.com/the-environment-cookbook-pattern/#thewrappercookbook
