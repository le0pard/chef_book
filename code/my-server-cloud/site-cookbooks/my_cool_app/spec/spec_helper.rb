require 'chefspec'
require 'chefspec/berkshelf' # if you are using librarian, when you should require 'chefspec/librarian'
require 'chefspec/server' # chef zero

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  config.log_level = :warn

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '12.04'
end