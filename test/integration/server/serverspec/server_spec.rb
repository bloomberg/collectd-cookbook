require 'spec_helper'

describe file('/etc/collectd.d/network.conf') do
  it { should be_file }
end
