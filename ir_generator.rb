require_relative "./token"

module IR
  PUTOBJECT = "putobject"
  OPT_PLUS = "opt_plus"

  OPT_LOOKUP = {
    TokenType::PLUS => OPT_PLUS
  }

  IRInstruction = Struct.new(:instruction, :value) do
    def print
      "#{instruction}       #{value}"
    end
  end

  class Generator
    def initialize(ast)
      @ast = ast
      @instructions = []
    end

    def generate_ir
      process_node(@ast)
      @instructions
    end

    def process_node(node)
      if node.respond_to? :value
        @instructions << IRInstruction.new(IR::PUTOBJECT, node.value)
        return
      end
      process_node(node.left) if node.respond_to? :left
      process_node(node.right) if node.respond_to? :right
      @instructions << IRInstruction.new(IR::OPT_LOOKUP[node.operator.type], nil)
    end
  end
end
