# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'awesome_print'

Gem::Specification.new do |spec|
  spec.name          = "js_model_generator"
  spec.version       = '0.0.1'
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
  spec.executables   = %w( jsmodgen )
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'cli_helper',    '~> 0.1', '>= 0.1.6'
  spec.add_runtime_dependency 'spreadsheet',   '~> 1.0', '>= 1.0.8'
  spec.add_runtime_dependency 'uuidtools',     '~> 2.1', '>= 2.1.5'
  spec.add_runtime_dependency 'awesome_print', '~> 1.6', '>= 1.6.1'

  spec.add_development_dependency 'bundler',  '~> 1.10'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8.2'
  spec.add_development_dependency "debug_me", '~> 1.0.2'

end
