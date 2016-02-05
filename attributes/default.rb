#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
default['collectd']['service_name'] = 'collectd'
default['collectd']['service_user'] = 'collectd'
default['collectd']['service_group'] = 'collectd'

default['collectd']['service']['config_directory'] = '/etc/collectd.d'
default['collectd']['service']['configuration']['plugin_dir'] =
  value_for_platform_family(
    'rhel' => '/usr/lib64/collectd',
    'debian' => '/usr/lib/collectd'
  )
default['collectd']['service']['configuration']['types_d_b'] = '/usr/share/collectd/types.db'
default['collectd']['service']['configuration']['interval'] = 10
default['collectd']['service']['configuration']['read_threads'] = 5
default['collectd']['service']['configuration']['write_threads'] = 5
default['collectd']['service']['configuration']['collect_internal_stats'] = true
