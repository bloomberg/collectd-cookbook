#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
include_recipe 'collectd::default'

collectd_plugin 'network' do
  user node['collectd']['service_user']
  group node['collectd']['service_group']
  options node['collectd']['client']['options'] unless node['collectd']['client'].nil?
  notifies :restart, "collectd_service[#{node['collectd']['service_name']}]", :delayed
end
