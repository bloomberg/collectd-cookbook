require 'spec_helper'

describe_recipe 'collectd::client' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  it { expect(chef_run).to include_recipe('collectd::default') }

  it do
    expect(chef_run).to create_collectd_plugin('network')
    .with(options: {'servers' => []})
  end

  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
