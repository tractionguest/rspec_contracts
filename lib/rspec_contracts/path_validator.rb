class RspecContracts::PathValidator
  class << self
    def validate_path(op, method, path)
      lookup_path = path.remove(RspecContracts.config.base_path)
      return if operation_matches_request?(op, method, lookup_path)

      msg = "#{method.upcase} #{path} does not resolve to #{op.operation_id}"
      raise RspecContracts::Error::PathValidation.new(msg)  if RspecContracts.config.path_validation_mode == :raise 
    
      puts "Contract validation warning: #{msg}"
    end

    def operation_matches_request?(op, method, path)
      op.root.request_operation(method.to_sym, path)&.operation_object == op
    end
  end
end
