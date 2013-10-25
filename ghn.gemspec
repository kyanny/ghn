# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghn/version'

Gem::Specification.new do |spec|
  spec.name          = "ghn"
  spec.version       = Ghn::VERSION
  spec.authors       = ["Kensuke Nagae"]
  spec.email         = ["kyanny@gmail.com"]
  spec.description   = %q{Commandline tool for GitHub notifications}
  spec.summary       = %q{Ghn is a commandline tool for GitHub notifications. You can listup all unread notifications and mark them as read.}
  spec.homepage      = "https://github.com/kyanny/ghn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "github_api"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
