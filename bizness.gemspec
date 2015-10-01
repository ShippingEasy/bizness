# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bizness/version'

Gem::Specification.new do |spec|
  spec.name          = "bizness"
  spec.version       = Bizness::VERSION
  spec.authors       = ["ShippingEasy"]
  spec.email         = ["dev@shippingeasy.com"]

  spec.summary       = "Get your bizness right and organize your business logic into operations."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "i18n"
  spec.add_dependency "hey-pubsub", "~> 0.2.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
