require 'rspec'
require 'thor'
require 'ghn'
require 'json'

module Helper
  def fixture(name)
    JSON.parse(File.read(File.join(__dir__, 'fixtures', name)), symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include Helper
end
