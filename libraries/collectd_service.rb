#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module CollectdCookbook
  module Resource
    # A resource for managing the collectd monitoring daemon.
    # @since 2.0.0
    class CollectdService < Chef::Resource
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin

      attribute(:command, kind_of: String, default: lazy { default_command })

      # @!attribute user
      # User to run the collectd daemon as. Defaults to 'collectd.'
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')

      # @!attribute group
      # Group to run the collectd daemon as. Defaults to 'collectd.'
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')

      # @!attribute directory
      # The working directory for the service. Defaults to the data
      # directory '/var/lib/collectd'.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/lib/collectd')

      # @!attribute configuration_directory
      # Name of directory where additional configurations reside. Defaults to
      # '/etc/collectd.d'.
      # @return [String]
      attribute(:config_directory, kind_of: String, default: '/etc/collectd.d')

      # @!attribute config_filename
      # The configuration file for the daemon service. Defaults to
      # '/etc/collectd.conf'.
      # @return [String]
      attribute(:config_filename, kind_of: String, default: '/etc/collectd.conf')

      # @!attribute configuration
      # Set of key-value options to write to {#config_filename}.
      # @see {https://collectd.org/documentation/manpages/collectd.conf.5.shtml#global_options}
      # @return [Hash, Mash]
      attribute(:configuration, option_collector: true, default: lazy { default_configuration })

      # @!attribute package_name
      # @return [String]
      attribute(:package_name, kind_of: String, default: 'collectd')

      # @!attribute package_version
      # @return [String]
      attribute(:package_version, kind_of: String)

      # @!attribute package_source
      # @return [String]
      attribute(:package_source, kind_of: String)

      # @!attribute environment
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { 'PATH' => '/usr/bin:/bin:/usr/sbin:/sbin' })

      # @return [String]
      def default_command
        "/usr/sbin/collectd -C #{config_filename}"
      end

      def default_configuration
        { 'pid_file' => ::File.join(directory, 'collectd.pid') }
      end
    end
  end

  module Provider
    # A provider for managing collectd daemon as a service.
    # @since 2.0.0
    class CollectdService < Chef::Provider
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          # TODO: (jbellone) Fix the package resource for AIX so that
          # it is able to install from a URL.
          package_path = if new_resource.package_source
                           url = new_resource.package_source % { version: new_resource.package_version }
                           basename = ::File.basename(url)
                           remote_file ::File.join(Chef::Config[:file_cache_path], basename) do
                             source url
                             backup false
                           end.path
                         end

          package new_resource.package_name do
            provider Chef::Provider::Package::Solaris if platform?('solaris2')
            provider Chef::Provider::Package::Dpkg if platform?('ubuntu') && new_resource.package_source
            action :upgrade
            version new_resource.package_version
            source package_path
            notifies :restart, new_resource, :delayed
          end

          # Installing package starts collectd service automatically
          # Disable this so that collectd can be managed through poise-service
          service new_resource.package_name do
            action [:disable, :stop]
            only_if { platform?('ubuntu') }
          end

          [new_resource.directory, new_resource.config_directory].each do |dirname|
            directory dirname do
              recursive true
              owner new_resource.user
              group new_resource.group
              mode '0755'
            end
          end

          collectd_config new_resource.config_filename do
            owner new_resource.user
            group new_resource.group
            configuration new_resource.configuration.merge(
              'base_dir' => new_resource.directory,
              'pid_file' => new_resource.configuration['pid_file'],
              'include'  => "#{new_resource.config_directory}/*.conf"
            )
            notifies :restart, new_resource, :delayed
          end
        end
        super
      end

      def action_disable
        notifying_block do
          collectd_config new_resource.config_filename do
            action :delete
          end
        end
        super
      end

      # Sets the tuning options for service management with {PoiseService::ServiceMixin}.
      # @param [PoiseService::Service] service
      def service_options(service)
        service.command(new_resource.command)
        service.environment(new_resource.environment)
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.environment(new_resource.environment)
        service.options :systemd, template: 'collectd:systemd.erb'
        service.options :upstart, template: 'collectd:upstart.erb'
        service.restart_on_update(true)
      end
    end
  end
end
