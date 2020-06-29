# frozen_string_literal: true

require 'active_support/lazy_load_hooks'
require "rspec_contracts/engine"
require "rspec_contracts/integration"
require 'rspec_contracts/contract'
require 'rspec_contracts/operation'
require 'rspec_contracts/error'
require 'rspec_contracts/error/operation_lookup'
require 'rspec_contracts/error/request_validation'
require 'rspec_contracts/error/response_validation'
require 'rspec_contracts/error/path_validation'
require 'rspec_contracts/error/schema'
require 'rspec_contracts/path_validator'
require 'rspec_contracts/request_validator'
require 'rspec_contracts/response_validator'
require 'rspec_contracts/railtie' if defined?(Rails::Railtie)
require "openapi_parser"

module RspecContracts
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new
  end

  def self.install
    ActiveSupport.on_load(:action_dispatch_integration_test) do
      include RspecContracts::Integration
    end

    RspecContracts.config.base_path ||= ""
    RspecContracts.config.request_validation_mode ||= :raise
    RspecContracts.config.response_validation_mode ||= :raise
    RspecContracts.config.path_validation_mode ||= :raise
    RspecContracts.config.strict_response_validation ||= true
    RspecContracts.config.logger ||= Logger.new("log/rspec_contracts.log")
  end

  def self.valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end
