require 'spec_helper'

describe group('collectd') do
  it { should exist }
end

describe user('collectd') do
  it { should exist }
end

describe directory('/etc/collectd.d/collectd-web') do
  it { should be_directory }
  it { should be_owned_by 'collectd' }
  it { should be_grouped_into 'collectd' }
end
