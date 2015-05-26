require 'server_spec'

describe file('/etc/collectd.d/network.conf') do
  it { should be_file }
end
