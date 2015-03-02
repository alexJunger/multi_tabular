require 'active_record'
require 'multi_tabular'

require 'support/database'
require 'support/models'
require 'support/tables'

module MultiTabularSpecHelper
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  include MultiTabularSpecHelper

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end