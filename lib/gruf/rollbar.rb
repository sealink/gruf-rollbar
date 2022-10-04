# frozen_string_literal: true

require 'gruf'
require 'rollbar'

# use Zeitwerk to lazily autoload all the files in the lib directory
require 'zeitwerk'
root_path = File.dirname(__dir__)
loader = ::Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = ::Zeitwerk::GemInflector.new(__FILE__)
loader.ignore(File.join(root_path, 'gruf-rollbar.rb'))
loader.push_dir(root_path)
loader.setup

module Gruf
  module Rollbar
    extend Gruf::Rollbar::Configuration
  end
end
