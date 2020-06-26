class RspecContracts::RequestValidator
  class << self
    def validate_request(op, request)
      op.validate_request_body(request.content_type, JSON.parse(request.body.read), opts)
    rescue OpenAPIParser::OpenAPIError => e
      raise OpenApiRequestError.new(e.message) #if config.validation_mode == :raise
      puts "#{e}" # if config.validation_mode == :warn
    end

    def opts
      OpenAPIParser::SchemaValidator::Options.new(coerce_value: true, datetime_coerce_class: DateTime)
    end
  end
end
