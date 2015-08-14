require 'rubygems'
require 'rspec'
require 'rspec/its'
require 'puppetlabs_spec_helper/module_spec_helper'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

#RSpec.configure.do |c|
  # Override puppetlabs_spec_helper's stupid setting of mock_with to :mocha,
  #c.mock_with :rspec
  #c.deprecation_stream = '/dev/null'
#end

# a simple class to inject :undef
# https://groups.google.com/d/msg/puppet-users/6nL2eROH8is/UDqRNu34lB0J
class Undef
  def inspect
    'undef'
  end
end
