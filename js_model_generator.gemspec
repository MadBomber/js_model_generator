# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'js_model_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "js_model_generator"
  spec.version       = JsModelGenerator::VERSION
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]

  spec.summary       = %q{Generates some Javascript code for sequelize models, migrations and sql and csv files from an XLS spreadsheet.}
  spec.description   = %q{Generates some Javascript code for sequelize models, migrations and sql and csv files from an XLS spreadsheet.}
  spec.homepage      = "http://github.com/MadBomber/js_model_generater"
  spec.license       = "You want it?  Its yours."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
