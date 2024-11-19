require_relative "./ir_generator"

class InstructionSet 
  INSTRUCTIONS_FILE = "./output/picoruby.s"
  ASSEMBLED_FILE = "./output/picoruby.o"
  EXEC = "./output/picoruby"

  def initialize(ir)
    @ir = ir
    @puts_register_uses = 0
    @pre_op_puts = 0
    @opt_value = false
  end

  def gernate_instruction_set
    File.open(INSTRUCTIONS_FILE, "w") do |f|
      f.write generate_header
        @ir.each do |ir_instruction|
          f.write generate_instruction(ir_instruction)
        end
      f.write generate_return
    end
  end

  def to_hex(number)
    "0x#{number.to_s(16).rjust(4, '0')}"
  end
end

class MacOSARM64InstructionSet < InstructionSet
  REGISTERS = ["X0, X1, X2"]
  PUT_REGISTERS = ["X0", "X1"]
  OPT_REGISTER = "X2"

  def generate_header
    <<~EOS
      .global _main             // Define the global entry point for macOS
      .align 2                  // Ensure 4-byte alignment (2^2 = 4 bytes)

        _main:
    EOS
  end

  def generate_return
    register = if @opt_value
      OPT_REGISTER
    else 
      PUT_REGISTERS[(@puts_register_uses - 1) % PUT_REGISTERS.length]
    end
      <<~EOS
          MOV X0, #{register}                // Move the result into X0 as the return value
          RET
      EOS
  end

  def generate_instruction(ir_instruction)
    case ir_instruction.instruction
    when IR::PUTOBJECT
      register = PUT_REGISTERS[@puts_register_uses % PUT_REGISTERS.length]
      @puts_register_uses +=1 
      @pre_op_puts += 1

      return "    MOVZ #{register}, ##{to_hex(ir_instruction.value)}\n" #fix register
    when IR::OPT_PLUS
      param_reg1 = PUT_REGISTERS[(@puts_register_uses - 1) % PUT_REGISTERS.length]
      param_reg2 = @pre_op_puts < 2 ? OPT_REGISTER : PUT_REGISTERS[(@puts_register_uses - 2) % PUT_REGISTERS.length]
      @opt_value = true
      @pre_op_puts = 0

      return "    ADD #{OPT_REGISTER}, #{param_reg1}, #{param_reg2}\n" # fix registers
    end
  end

  def assemble_link_run
    raise StandardError, "You must generate assembly instructions first" unless File.file?(INSTRUCTIONS_FILE)
    system("as -o #{ASSEMBLED_FILE} #{INSTRUCTIONS_FILE}") # assemble the program
    system("clang -o #{EXEC} #{ASSEMBLED_FILE} -Wl,-e,_main") # link it
    system("#{EXEC}; echo $?") # run it! and echo it!
  end
end

