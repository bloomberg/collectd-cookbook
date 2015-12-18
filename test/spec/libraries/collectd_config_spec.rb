require 'chefspec'
require 'chefspec/berkshelf'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/collectd_config'

describe CollectdCookbook::Resource::CollectdConfig do
  step_into(:collectd_config)
  context '#snake_to_camel' do
    recipe do
      collectd_config '/etc/collectd.conf' do
        configuration(
          'load_plugin' => 'foo',
          'format' => 'bar',
          'j_s_o_n' => 'baz'
        )
      end

      it { expect(chef_run).to render_file('/etc/collectd.conf').with_content(<<-EOH.chomp) }
LoadPlugin "foo"
Format "bar"
JSON "baz"
EOH
    end
  end

  context '#write_elements' do
    recipe do
      collectd_config '/etc/collectd.conf' do
        configuration('hash' => {
          'id' => 'id',
          'string' => 'string',
          'integer' => 1,
          'true_class' => true,
          'false_class' => false,
          'symbol' => :symbol,
          'array' => %w{1 2 3},
          'hash' => {
            'id' => 'id',
            'string' => 'string'
          }
        })
      end
    end

    it { expect(chef_run).to render_file('/etc/collectd.conf').with_content(<<-EOH.chomp) }
<Hash "id">
	String "string"
	Integer 1
	TrueClass true
	FalseClass false
	Symbol symbol
	Array "1"
	Array "2"
	Array "3"
	<Hash "id">
		String "string"
	</Hash>
</Hash>
EOH
  end
end
