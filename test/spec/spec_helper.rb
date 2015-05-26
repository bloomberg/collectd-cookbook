require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

RSpec.configure do |config|
  # Set default platform family and version for ChefSpec.
  config.platform = 'redhat'
  config.version = '6.4'

  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe
  config.alias_example_group_to :describe_resource, type: :resource

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  Kernel.srand config.seed
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

at_exit { ChefSpec::Coverage.report! }

module ChefSpec::Macros
  alias_method :described_resource, :described_recipe
end

RSpec.shared_context 'recipe tests', type: :recipe do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
end
