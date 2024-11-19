require "optparse"
require_relative "./scanner"
require_relative "./parser"
require_relative "./ir_generator"
require_relative "./instruction_set"

source = ""
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: picoruby.rb <filename> [options]"

  opts.on("-v", "--verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

if ARGV.size != 1
  puts "Usage: ruby picoruby.rb <filename>"
  exit
else
  source = File.read(ARGV[0])
end

scanner = Scanner.new(source)
tokens = scanner.tokenize
if options[:verbose]
  puts ""
  puts "Tokens"
  puts "------"
  puts tokens
  puts ""
end
parser = Parser.new(tokens)
ast = parser.parse
if options[:verbose]
  puts ""
  puts "Abstract Syntax Tree"
  puts "--------------------"
  puts ast.parenthesize
  puts ""
end
ir = IR::Generator.new(ast)
ir_set = ir.generate_ir
if options[:verbose]
  puts ""
  puts "IR Instruction Set"
  puts "------------------"
  ir_set.each do |i|
    puts i.print
  end
  puts ""
end
instruction_set = MacOSARM64InstructionSet.new(ir_set)
instruction_set.gernate_instruction_set
if options[:verbose]
  puts "Assembly Code"
  puts "-------------"
  puts MacOSARM64InstructionSet::INSTRUCTIONS_FILE
  puts ""
end
instruction_set.assemble_link_run
