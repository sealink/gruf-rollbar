# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gruf/rollbar/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-rollbar'
  spec.version       = Gruf::Rollbar::VERSION
  spec.authors       = ['SeaLink']
  spec.email         = ['john.zhao@kelsian.com']
  spec.license       = 'MIT'

  spec.summary       = %q{Automatically report gruf failures as rollbar errors}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/sealink/gruf-rollbar'

  spec.required_ruby_version = '>= 2.7'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-rollbar.gemspec']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler-audit', '>= 0.6'
  spec.add_development_dependency 'rake', '>= 12.3'
  spec.add_development_dependency 'rubocop', '>= 1.27'
  spec.add_development_dependency 'pry', '>= 0.14'
  spec.add_development_dependency 'rspec', '>= 3.8'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4'
  spec.add_development_dependency 'simplecov', '>= 0.16'

  spec.add_runtime_dependency 'gruf', '~> 2.5', '>= 2.5.1'
  spec.add_runtime_dependency 'rollbar'
  spec.add_runtime_dependency 'zeitwerk', '~> 2'
end
