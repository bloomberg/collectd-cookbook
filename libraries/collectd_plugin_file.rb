#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CollectdCookbook
  module Resource
    # A resource for managing collectd plugins.
    # @since 2.0.0
    class CollectdPluginFile < Chef::Resource
      include Poise(fused: true)
      provides(:collectd_plugin_file)

      # @!attribute plugin_name
      # Name of the collectd plugin to install and configure.
      # @return [String]
      attribute(:plugin_name, kind_of: String, name_attribute: true)

      # @!attribute plugin_instance_name
      # Name of the plugin instance name
      # @return [String]
      attribute(:plugin_instance_name, kind_of: String)

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

      # @!attribute cookbook
      # The name of the cookbook where template file lives
      # @return [String]
      attribute(:cookbook, kind_of: String)

      # @!attribute source
      # The name of the template file in templates directory
      # @return [String]
      attribute(:source, kind_of: String)

      # @!attribute variables
      # A Hash of variables that are used to replace variables in the
      # template file
      attribute(:variables, kind_of: Hash)

      # @return [String]
      def config_filename
        ::File.join(directory, "#{plugin_name}_#{plugin_instance_name}.conf")
      end

      action(:create) do
        notifying_block do
          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end

          template new_resource.config_filename do
            owner new_resource.user
            group new_resource.group
            cookbook new_resource.cookbook
            source new_resource.source
            variables new_resource.variables
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
