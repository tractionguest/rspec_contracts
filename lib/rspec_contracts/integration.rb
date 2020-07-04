module RspecContracts::Integration
  http_verbs = %w(get post patch put delete)

  http_verbs.each do |method|
    define_method(method) do |*args, **kwargs|
      request_path = args.first
      api_operation = kwargs.delete(:api_operation)
      api_version = kwargs.delete(:api_version)
      super(*args, **kwargs).tap do |status_code|
        return unless api_operation # even a not found contract lookup will still be present
        return if api_version.present? && !Semverse::Constraint.new(api_operation.root.version).include?(api_version)
        raise RspecContracts::Error::OperationLookup.new("Operation not found") unless api_operation.valid?

        RspecContracts.config.logger.tagged("rspec_contracts", api_operation.operation_id) do

          RspecContracts::PathValidator.validate_path(api_operation, method, request_path) unless RspecContracts.config.path_validation_mode == :ignore
          RspecContracts::RequestValidator.validate_request(api_operation, request) unless RspecContracts.config.request_validation_mode == :ignore

          unless RspecContracts.config.response_validation_mode == :ignore
            parsed_body = RspecContracts.valid_json?(response.body) ? JSON.parse(response.body) : nil 
            validatable_response = OpenAPIParser::RequestOperation::ValidatableResponseBody.new(status_code, parsed_body, response.headers)
            RspecContracts::ResponseValidator.validate_response(api_operation, validatable_response)
          end
        end
      end
    end
  end
end
