#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
include_recipe 'yum-epel::default' if platform_family?('redhat')

poise_service_user node['collectd']['service_user'] do
  group node['collectd']['service_group']
  not_if { node['collectd']['service_user'] == 'root' }
end

collectd_service node['collectd']['service_name'] do
  user node['collectd']['service_user']
  group node['collectd']['service_group']
  node['collectd']['service'].each_pair { |k, v| send(k, v) }
end
