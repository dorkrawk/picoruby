require_relative "token"

class Scanner
  def initialize(source)
    @source = source
    @start = 0
    @current = 0
    @tokens = []
  end

  def tokenize
    while !at_end?
      @start = @current
      scan_token
    end
    @tokens << Token.new(TokenType::EOF, "")
  end

  def scan_token
    c = advance

    case c
    when '+'
      add_token(TokenType::PLUS)
    when " ", "\r", "\t", "\n"
      # Ignore whitespace.
    else
      if is_digit?(c)
        number
      else
        raise StandardError, "Unexpected character found: #{c.inspect}."
      end
    end
  end

  def number
    while is_digit?(peek)
      advance
    end

    add_token(TokenType::NUMBER, @source[@start..@current].to_i)
  end

  def add_token(token_type, value = nil)
    new_token = Token.new(token_type, value)
    @tokens << new_token
  end

  def advance
    c = @source[@current]
    @current += 1
    c
  end

  def peek
    return '\0' if at_end?
    @source[@current]
  end

  def is_digit?(c)
    c >= '0' && c <= '9'
  end

  def at_end?
    @current >= @source.size
  end
end
