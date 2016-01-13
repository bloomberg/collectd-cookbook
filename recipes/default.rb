#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['collectd']['service_user'] do
  group node['collectd']['service_group']
  not_if { node['collectd']['service_user'] == 'root' }
end

collectd_service node['collectd']['service_name'] do |r|
  user node['collectd']['service_user']
  group node['collectd']['service_group']
  node['collectd']['service'].each_pair { |k, v| r.send(k, v) }
end
