class RspecContracts::Contract
  def initialize(schema)
    @root = OpenAPIParser.parse(schema)
  end

  def [](key)
    raise RspecContracts::Error::OperationLookup.new("Operation [#{key}] not found") unless operations.key?(key)

    operations[key]
  end

  def operations
    @operations ||= paths.map do |p|
      p._openapi_all_child_objects.values.map do |op| 
        next unless op.respond_to?(:operation_id)

        [op.operation_id, RspecContracts::Operation.new(op)]
      end.compact.to_h
    end.inject(:merge).with_indifferent_access
  end

  def paths
    @paths ||= @root.paths._openapi_all_child_objects.values
  end

  def method_missing(m, *args, &block)
    @root.send(m, *args, &block)
  end
end
