# frozen_string_literal: true

require_relative 'simplecov_helper'

require 'grpc'
require 'gruf-rollbar'
require 'pry'

Dir["#{File.join(File.dirname(__FILE__), 'support')}/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end
  config.color = true

  config.include Gruf::Rollbar::SpecHelpers
end