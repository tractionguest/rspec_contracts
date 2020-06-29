class RspecContracts::Contract
  def initialize(schema)
    @schema = schema.with_indifferent_access
    @root = OpenAPIParser.parse(schema)
  end

  def [](key)
    return RspecContracts::Operation.new(nil, self) unless operations.key?(key)

    operations[key]
  end

  def version
    @schema[:info][:version]
  rescue NoMethodError => _e
    raise RspecContracts::Error.new("Version not found in schema")
  end

  def operations
    @operations ||= paths.map do |p|
      p._openapi_all_child_objects.values.map do |op| 
        next unless op.respond_to?(:operation_id)

        [op.operation_id, RspecContracts::Operation.new(op, self)]
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
