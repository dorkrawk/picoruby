module Expr
  class Binary
    attr_reader :left, :operator, :right
    
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    def parenthesize
      "(#{operator.type} #{left.parenthesize} #{right.parenthesize})"
    end
  end
end

module Expr
  class Literal
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def parenthesize
      "(#{value.to_s})"
    end
  end
end

