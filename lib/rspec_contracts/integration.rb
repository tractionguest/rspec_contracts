module RspecContracts::Integration
  http_verbs = %w(get post patch put delete)

  http_verbs.each do |method|
    define_method(method) do |*args, **kwargs|
      request_path = args.first
      api_operation = kwargs.delete(:api_operation)
      super(*args, **kwargs).tap do |status_code|
        return unless api_operation

        RspecContracts::PathValidator.validate_path(api_operation, method, request_path) unless RspecContracts.config.path_validation_mode == :ignore
        RspecContracts::RequestValidator.validate_request(api_operation, request) unless RspecContracts.config.request_body_validation_mode == :ignore

        unless RspecContracts.config.response_validation_mode == :ignore 
          validatable_response = OpenAPIParser::RequestOperation::ValidatableResponseBody.new(status_code, JSON.parse(response.body), response.headers)
          RspecContracts::ResponseValidator.validate_response(api_operation, validatable_response)
        end
      end
    end
  end
end
