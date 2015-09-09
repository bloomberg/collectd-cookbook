require 'chefspec'
require 'chefspec/berkshelf'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/collectd_service'

describe CollectdCookbook::Resource::CollectdService do
  step_into(:collectd_service)
  context 'with default attributes' do
    recipe do
      collectd_service 'collectd'
    end

    it do
      expect(chef_run).to create_directory('/etc/collectd.d')
      .with(owner: 'collectd', group: 'collectd', mode: '0755')
    end

    it do
      expect(chef_run).to create_collectd_config('/etc/collectd.conf')
      .with(configuration: {
        'include' => '/etc/collectd.d/*.conf',
        'base_dir' => '/var/lib/collectd'
      })
    end
  end
end
