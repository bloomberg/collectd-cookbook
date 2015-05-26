require 'spec_helper'

describe_recipe 'collectd::web' do
  it { expect(chef_run).to include_recipe('collectd::default') }
  it { expect(chef_run).to create_httpd_service('default') }
  it { expect(chef_run).to enable_httpd_service('default') }
  it { expect(chef_run).to create_httpd_config('default') }
  it { expect(chef_run).to create_directory('/etc/collectd.d/collectd-web') }
  it { expect(chef_run).to render_file('/etc/collectd.d/collection.conf') }
  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
