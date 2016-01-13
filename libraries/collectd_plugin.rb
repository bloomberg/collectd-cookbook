#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CollectdCookbook
  module Resource
    # A resource for managing collectd plugins.
    # @since 2.0.0
    class CollectdPlugin < Chef::Resource
      include Poise(fused: true)
      provides(:collectd_plugin)

      # @!attribute plugin_name
      # Name of the collectd plugin to install and configure.
      # @return [String]
      attribute(:plugin_name, kind_of: String, name_attribute: true)

      # @!attribute directory
      # Name of directory where plugin configuration resides. Defaults to
      # '/etc/collectd.d'.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/etc/collectd.d')

      # @!attribute user
      # User which the configuration for {#plugin_name} is owned by.
      # Defaults to 'collectd.'
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')

      # @!attribute group
      # Group which the configuration for {#plugin_name} is owned by.
      # Defaults to 'collectd.'
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')

      # @!attribute options
      # Set of key-value options to configure the plugin.
      # @return [Hash, Mash]
      attribute(:options, option_collector: true)

      # @return [String]
      def config_filename
        ::File.join(directory, "#{plugin_name}.conf")
      end

      action(:create) do
        notifying_block do
          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end

          collectd_config new_resource.config_filename do
            owner new_resource.user
            group new_resource.group
            configuration(
              'load_plugin' => new_resource.plugin_name,
              'plugin' => {
                'id' => new_resource.plugin_name
              }.merge(new_resource.options)
            )
          end
        end
      end

      action(:delete) do
        notifying_block do
          collectd_config new_resource.config_filename do
            action :delete
          end
        end
      end
    end
  end
end
