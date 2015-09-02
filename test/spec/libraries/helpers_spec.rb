require_relative '../../../libraries/helpers'
describe CollectdCookbook::Helpers do
  let(:subject) do
    Class.new { include CollectdCookbook::Helpers }.new
  end

  it { is_expected.to respond_to(:snake_to_camel).with(1).arguments }
  it { is_expected.to respond_to(:build_configuration).with(1).arguments }
  it { is_expected.to respond_to(:build_configuration).with(2).arguments }

  context '#snake_to_camel' do
    it { expect(subject.snake_to_camel('load_plugin')).to eq('LoadPlugin') }
    it { expect(subject.snake_to_camel('format')).to eq('Format') }
    it { expect(subject.snake_to_camel('j_s_o_n')).to eq('JSON') }
  end

  context '#build_configuration' do
    it { expect(subject.build_configuration('string' => 'string')).to eq(%(String "string")) }
    it { expect(subject.build_configuration('integer' => 1)).to eq(%(Integer 1)) }
    it { expect(subject.build_configuration('true_class' => true)).to eq(%(TrueClass true)) }
    it { expect(subject.build_configuration('false_class' => false)).to eq(%(FalseClass false)) }
    it { expect(subject.build_configuration('symbol' => :symbol)).to eq(%(Symbol symbol)) }
    it { expect(subject.build_configuration('array' => [1, 2, 3])).to eq(%(Array "1", "2", "3")) }

    it do
      expect(subject.build_configuration('hash' => {
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
      })).to eq(<<-EOH.chomp)
<Hash "id">
	String "string"
	Integer 1
	TrueClass true
	FalseClass false
	Symbol symbol
	Array "1", "2", "3"
	<Hash "id">
		String "string"
	</Hash>
</Hash>
EOH
    end

  end
end
