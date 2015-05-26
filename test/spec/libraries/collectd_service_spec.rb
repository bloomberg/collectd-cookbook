require 'chefspec/berkshelf'
require 'poise_boiler/spec_helper'
require_relative '../../../libraries/collectd_plugin'

describe CollectdCookbook::Resource::CollectdService do
  step_into(:collectd_service)
end
