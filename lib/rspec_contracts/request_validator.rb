class RspecContracts::RequestValidator
  def validate_request(req, op)
    op.validate_request_body(req.content_type, JSON.parse(req.body.read), OpenAPIParser::SchemaValidator::Options.new)
  rescue OpenAPIParser::OpenAPIError => e
    raise OpenApiRequestError.new(e.message) #if config.validation_mode == :raise
    puts "#{e}" # if config.validation_mode == :warn
  end
end
