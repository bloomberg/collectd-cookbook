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
    # A resource which manages collectd daemon configurations.
    # @since 1.0.0
    # @example
    # collectd_config '/etc/collectd.conf' do
    #   configuration('read_threads' => 5,
    #     'write_threads' => 5,
    #     'interval' => 10
    #   )
    # end
    class CollectdConfig < Chef::Resource
      include Poise(fused: true)
      provides(:collectd_config)

      attribute(:path, kind_of: String, name_attribute: true)
      attribute(:owner, kind_of: String, default: 'collectd')
      attribute(:group, kind_of: String, default: 'collectd')
      attribute(:mode, kind_of: String, default: '0644')

      attribute(:configuration, option_collector: true)

      # Produces collectd {configuration} elements from resource.
      # @return [String]
      def content
        write_elements(configuration).concat("\n")
      end

      # Converts from snake case to a camel case string.
      # @param [String, Symbol] s
      # @return [String]
      def snake_to_camel(s)
        s.to_s.split('_').map(&:capitalize).join('')
      end

      # Recursively writes out configuration elements from
      # {directives} and applies the appropriate {indent}.
      # @param [Hash] directives
      # @param [Integer] indent
      # @return [String]
      def write_elements(directives, indent = 0)
        tabs = ("\t" * indent)
        directives.dup.map do |key, value|
          next if value.nil?
          key = snake_to_camel(key)
          if value.is_a?(Array)
            value.map do |val|
              if val.is_a?(String)
                %(#{tabs}#{key} "#{val}")
              else
                %(#{tabs}#{key} #{val})
              end
            end.join("\n")
          elsif value.kind_of?(Hash) # rubocop:disable Style/ClassCheck
            id = value.delete('id')
            next if id.nil?
            [%(#{tabs}<#{key} "#{id}">),
             write_elements(value, indent.next),
             %(#{tabs}</#{key}>)
            ].join("\n")
          elsif value.is_a?(String)
            %(#{tabs}#{key} "#{value}")
          else
            %(#{tabs}#{key} #{value})
          end
        end.flatten.join("\n")
      end

      action(:create) do
        notifying_block do
          directory ::File.dirname(new_resource.path) do
            recursive true
          end

          file new_resource.path do
            content new_resource.content
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
          end
        end
      end

      action(:delete) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
