class RspecContracts::ResponseValidator
  class << self
    def validate_response(op, resp)
      op.validate_response(resp, opts)
    rescue OpenAPIParser::OpenAPIError => e
      # byebug
      raise RspecContracts::Error::ResponseValidation.new(e.message) if RspecContracts.config.response_validation_mode == :raise
    
      puts "WARNING: Response validation error: #{e}"
    end

    def opts
      OpenAPIParser::SchemaValidator::ResponseValidateOptions.new(strict: RspecContracts.config.strict_response_validation)
    end
  end
end
