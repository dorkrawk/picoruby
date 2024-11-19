class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def to_s
    "<#{@type}, #{@value}>"
  end
end

module TokenType
  PLUS = "PLUS"
  NUMBER = "NUMBER"
  EOF = "END_OF_FILE"
end
