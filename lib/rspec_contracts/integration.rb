module RspecContracts::Integration
  http_verbs = %w(get post patch put delete)

  http_verbs.each do |method|
    define_method(method) do |*args, **kwargs|
      request_path = args.first
      api_operation = kwargs.delete(:api_operation)
      super(*args, **kwargs).tap do |status_code|
        return unless api_operation

        RspecContracts::PathValidator.validate_path(api_operation, method, request_path) unless RspecContracts.config.path_validation_mode == :ignore
        # validate_request(request, api_operation) # if config.validate_request?
        # resp = OpenAPIParser::RequestOperation::ValidatableResponseBody.new(status_code, JSON.parse(response.body), response.headers)
        # validate_response(resp, api_operation)
      end
    end
  end

  # def validate_path(op, method, path)
  #   lookup_path = path.gsub(/\/api\/v3/, "")
  #   return if ResponseValidator.operation_matches_request?(op, method, lookup_path)
  #   msg = "#{method.upcase} #{path} does not resolve to #{op.operation_id}"
  #   raise OpenAPIParser::OpenApiError.new(msg) # if config.validation_mode == :raise 
  
  #   puts msg  # if config.validation_mode == :warn
  # end

  # def validate_response(resp, op)
  #   op.validate_response(resp, OpenAPIParser::SchemaValidator::ResponseValidateOptions.new)
  # rescue OpenAPIParser::OpenAPIError => e
  #   raise OpenApiResponseError.new(e.message) #if config.validation_mode == :raise
  #   puts "#{e}" # if config.validation_mode == :warn
  # end
end
