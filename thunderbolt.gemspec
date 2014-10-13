# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thunderbolt/version'

Gem::Specification.new do |spec|
  spec.name          = "thunderbolt"
  spec.version       = Thunderbolt::VERSION
  spec.authors       = ["sumit"]
  spec.email         = ["sumit@codeignition.co"]
  spec.description   = %q{ultimate weapon for codeignition devops guy }
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "twist fuck do any thing you want to do"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|feautures_setup|tmp)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_runtime_dependency "colorize"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.13.0"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
end
