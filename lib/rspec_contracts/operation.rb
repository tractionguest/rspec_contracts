# frozen_string_literal: true

module RspecContracts
  class Operation
    attr_reader :root

    def initialize(op, root)
      @op = op
      @root = root
    end

    def valid?
      @op.present?
    end

    def ==(val)
      val == @op
    end

    def method_missing(m, *args, &block)
      @op.send(m, *args, &block)
    end
  end
end
