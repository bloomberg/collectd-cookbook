#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
require 'yaml'
include_recipe 'collectd::default'

package %w(libhtml-parser liburi-perl librrds-perl libjson-perl)

directory File.dirname(node['collectd']['web']['options']['data_dir']) do
  recursive true
  owner node['collectd']['service_user']
  group node['collectd']['service_group']
end

file '/etc/collectd.d/collection.conf' do
  content node['collectd']['web']['options'].to_yaml
  owner node['collectd']['service_user']
  group node['collectd']['service_group']
  mode '0640'
end

# TODO: (jbellone) libartifact

httpd_service 'default' do
  action [:create, :start]
end

httpd_config 'default' do
  notifies :restart, 'httpd_service[default]'
end
