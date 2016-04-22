# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plainrouter/version'

Gem::Specification.new do |spec|
  spec.name          = "plainrouter"
  spec.version       = PlainRouter::VERSION
  spec.authors       = ["Yusuke Wada"]
  spec.email         = ["yusuke@kamawada.com"]

  spec.summary       = %q{Fast and simple routing engine for Ruby}
  spec.description   = %q{PlainRouter is a fast and simple routing engine for Ruby. Using PlainRouter::Method, you can quickly make web application framework like Sinatra. PlainRouter is a porting project of Route::Boom.}
  spec.homepage      = "https://github.com/yusukebe/plainrouter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
