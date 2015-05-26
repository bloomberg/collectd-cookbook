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

if node['platform'] == 'ubuntu'
  default['collectd']['service']['package_name'] = 'collectd-core'
else
  default['collectd']['service']['package_name'] = 'collectd'
end

default['collectd']['service']['configuration']['plugin_dir'] = '/usr/lib64/collectd'
default['collectd']['service']['configuration']['types_d_b'] = '/usr/share/collectd/types.db'

default['collectd']['web']['options'] = { 'data_dir' => '/etc/collectd.d/collectd-web' }
default['collectd']['client']['options']['servers'] = []
default['collectd']['server']['options']['listen'] = '0.0.0.0'
