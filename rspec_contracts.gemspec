# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rspec_contracts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rspec_contracts"
  spec.version     = RspecContracts::VERSION
  spec.authors     = ["Steven Allen"]
  spec.email       = ["sallen@tractionguest.com"]
  spec.homepage    = "https://github.com/tractionguest/rspec-openapi-validator"
  spec.summary     = "RspecContracts"
  spec.description = "RspecContracts"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.4", ">= 5.2.4.3"
  spec.add_dependency "rspec-rails"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "overcommit"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-console"
  spec.add_development_dependency "sqlite3"
end
