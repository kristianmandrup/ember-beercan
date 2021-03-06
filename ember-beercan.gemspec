# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ember/beercan/version'

Gem::Specification.new do |spec|
  spec.name          = "ember-beercan"
  spec.version       = Ember::Beercan::VERSION
  spec.authors       = ["Kristian Mandrup"]
  spec.email         = ["kmandrup@gmail.com"]
  spec.description   = %q{Add Authentication and Authorization to your Ember app using auth tokens. Includes server side controller code for Rails 3.1+}
  spec.summary       = %q{Authentication and Authorization helpers for Ember (and Rails)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             'rails',      '>= 3.2.8'
  spec.add_dependency             'doorkeeper', '~> 0.6.7'

  spec.add_dependency             'cancan',     '~> 1.6'
  spec.add_dependency             'rails-api',  '~> 0.1.0'

  spec.add_development_dependency "bundler",    "~> 1.3"
  spec.add_development_dependency "rake"
end
