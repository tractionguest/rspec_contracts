# frozen_string_literal: true

module RspecContracts
  module Integration
    http_verbs = %w[get post patch put delete]

    def version_satisfied?(constraints, api_version)
      Array(constraints).all? { |constraint| Semverse::Constraint.new(constraint).satisfies?(api_version) }
    end

    http_verbs.each do |method|
      define_method(method) do |*args, **kwargs|
        request_path = args.first
        api_operation = kwargs.delete(:api_operation)
        api_version = kwargs.delete(:api_version)
        super(*args, **kwargs).tap do |status_code|
          next unless api_operation # even a not found contract lookup will still be present
          next if api_version.present? && !version_satisfied?(api_version, api_operation.root.version)
          raise RspecContracts::Error::OperationLookup.new("Operation not found") unless api_operation.valid?

          RspecContracts.config.logger.tagged("rspec_contracts", api_operation.operation_id) do
            unless RspecContracts.config.path_validation_mode == :ignore
              RspecContracts::PathValidator.validate_path(api_operation, method, request_path)
            end
            unless RspecContracts.config.request_validation_mode == :ignore
              RspecContracts::RequestValidator.validate_request(api_operation, request)
            end

            unless RspecContracts.config.response_validation_mode == :ignore
              parsed = RspecContracts.valid_json?(response.body) ? JSON.parse(response.body) : nil
              vr = OpenAPIParser::RequestOperation::ValidatableResponseBody.new(status_code, parsed, response.headers)
              RspecContracts::ResponseValidator.validate_response(api_operation, vr)
            end
          end
        end
      end
    end
  end
end
