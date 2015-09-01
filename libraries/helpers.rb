#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010 Atari, Inc.
# Copyright 2015 Bloomberg Finance L.P.
#

module CollectdCookbook
  module Helpers
    # Converts from snake case to a camel case string.
    # @param [String, Symbol] s
    # @param [String]
    # @return [String]
    def snake_to_camel(s)
      s.to_s.split('_').map(&:capitalize).join('')
    end

    # Builds a configuration file from {directives} and applys {indent}.
    # @param [Hash] directives
    # @param [Integer] indent
    # @return [String]
    def build_configuration(directives, indent = 0)
      tabs = ("\t" * indent)
      directives.map do |key, value|
        next if value.nil?
        key = snake_to_camel(key)
        if value.is_a?(Array)
          %(#{tabs}#{key} "#{value.uniq.join('", "')}")
        elsif value.kind_of?(Hash) # rubocop:disable Style/ClassCheck
          value.map do |n, v|
            n = snake_to_camel(n)
            %(#{tabs}<#{key} "#{n}">\n#{build_configuration(v, indent.next)}\n#{tabs}</#{key}>)
          end
        elsif value.is_a?(String)
          %(#{tabs}#{key} "#{value}")
        else
          %(#{tabs}#{key} #{value})
        end
      end.flatten.join("\n")
    end
  end
end
