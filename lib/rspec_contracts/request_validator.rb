class RspecContracts::RequestValidator
  class << self
    def validate_request(op, request)
      body = request.body.read
      parsed_body = RspecContracts.valid_json?(body) ? JSON.parse(request.body.read) : nil
      op.validate_request_body(request.content_type, parsed_body, opts)
    rescue OpenAPIParser::OpenAPIError => e
      raise RspecContracts::Error::RequestValidation.new(e.message) if RspecContracts.config.request_validation_mode == :raise

      formatted_for_logging = {
        body: parsed_body,
        headers: request.headers.to_h.select { |k, _| k.starts_with?("HTTP_") }.transform_keys { |k| k.remove("HTTP_").downcase }
      }
      RspecContracts.config.logger.error "Contract validation warning: #{e.message}"
      RspecContracts.config.logger.error "Request was: #{formatted_for_logging}"
    end

    def opts
      OpenAPIParser::SchemaValidator::Options.new(coerce_value: true, datetime_coerce_class: DateTime)
    end
  end
end
