require 'spec_helper'

describe group('collectd') do
  it { should exist }
end

describe user('collectd') do
  it { should exist }
end

describe file('/var/lib/collectd') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/lib64/collectd') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/collectd.d') do
  it { should be_directory }
  it { should be_owned_by 'collectd' }
  it { should be_grouped_into 'collectd' }
end

describe file('/etc/collectd.conf') do
  it { should be_file }
  it { should be_owned_by 'collectd'}
  it { should be_grouped_into 'collectd' }
  it { should contain 'Interval 10' }
  it { should contain 'ReadThreads 5' }
  it { should contain 'WriteThreads 5' }
  it { should_not contain 'Timeout' }
  it { should_not contain 'WriteQueueLimitHigh' }
  it { should_not contain 'WriteQueueLimitLow' }
  it { should contain 'Include "/etc/collectd.d"' }
end

describe file('/etc/collectd.d/threshold.conf') do
  it { should be_file }
  it { should be_owned_by 'collectd'}
  it { should be_grouped_into 'collectd' }
end
