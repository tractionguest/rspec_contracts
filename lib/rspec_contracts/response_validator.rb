class RspecContracts::ResponseValidator
  class << self
    def validate_response(op, resp)
      op.validate_response(resp, opts(has_content: resp.content_type.present?))
    rescue OpenAPIParser::OpenAPIError => e
      raise RspecContracts::Error::ResponseValidation.new(e.message) if RspecContracts.config.response_validation_mode == :raise
    
      RspecContracts.config.logger.error "Contract validation warning: #{e.message}"
      RspecContracts.config.logger.error "Response was: #{resp}"
    end

    def opts(has_content: true)
      OpenAPIParser::SchemaValidator::ResponseValidateOptions.new(strict: has_content && RspecContracts.config.strict_response_validation)
    end
  end
end
