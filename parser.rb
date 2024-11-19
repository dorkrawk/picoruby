require_relative "./expression"

class Parser
  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    return expression
  end
  
  def expression
    expr = term
    while match(TokenType::PLUS)
      operator = previous
      right = term
      expr = Expr::Binary.new(expr, operator, right)
    end
    expr      
  end

  def term
    primary
  end

  def primary
    if match(TokenType::NUMBER)
      return Expr::Literal.new(previous.value)
    else
      raise StandardError, "Expression expected."
    end
  end

  def match(token_type)
    if check(token_type)
      advance
      true
    else
      false
    end
  end

  def check(token_type)
    return false if is_at_end
    peek.type == token_type
  end

  def advance
    @current += 1 unless is_at_end
    previous
  end

  def is_at_end
    peek.type == TokenType::EOF
  end

  def peek
    @tokens[@current]
  end

  def previous
    @tokens[@current - 1]
  end
end
