class RspecContracts::Operation
  def initialize(op)
    @op = op
  end

  def ==(val)
    val == @op
  end

  def method_missing(m, *args, &block)
    @op.send(m, *args, &block)
  end
end
