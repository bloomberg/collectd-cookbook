require 'spec_helper'

describe_recipe 'collectd::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  it do
    expect(chef_run).to enable_collectd_service('collectd')
    .with(user: 'collectd')
    .with(group: 'collectd')
  end

  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
