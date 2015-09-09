require 'chefspec'
require 'chefspec/berkshelf'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/collectd_plugin'

describe CollectdCookbook::Resource::CollectdPlugin do
  step_into(:collectd_plugin)
  context 'enables syslog plugin' do
    recipe do
      collectd_plugin 'syslog' do
        options do
          log_level 'info'
        end
      end
    end

    it do
      expect(chef_run).to create_collectd_config('/etc/collectd.d/syslog.conf')
      .with(configuration: {
        'load_plugin' => 'syslog',
        'plugin' => {
          'id' => 'syslog',
          'log_level' => 'info'
        }
      })
    end
  end
end
