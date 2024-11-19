# Picoruby

A VERY partial implementation of Ruby that compiles down to machine code.

*By "VERY partial implementation" I mean it only supports positive integers (currently < 256) and addition.*

## How Do I Use It?

```
> ruby picoruby.rb your_code.rb
57
```

To see a verbose output of all the intermediate steps (tokens, abstract syntax tree, intermediate representation, machine code file) use the `-v` flag:

```
> ruby picoruby.rb your_code.rb -v

Tokens
------
<NUMBER, 23>
<PLUS, >
<NUMBER, 34>
<END_OF_FILE, >


Abstract Syntax Tree
--------------------
(PLUS (23) (34))


IR Instruction Set
------------------
putobject       23
putobject       34
opt_plus

Assembly Code
-------------
./output/picoruby.s

57
```

## Example Programs

```ruby
6 + 7
```

```ruby
1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9
```

```ruby
42
```

## Things Picoruby Does Not Support
- blocks
- `map`
- methods
- booleans
- strings
- subtraction
- literally anything other than positive integers and addition

## Current Issues (That I'd Like To Fix)
- support for integers over 255
- support for architectures other than ARM64
- some code organization and naming

## Current Issues (That I Don't Want To Fix)
- performance
- additional language functionality
- pretty much everything else

## Why Does This Even Exist?

I wanted to build a very easy to follow example of a tiny language so people could look at how code goes from text file to tokens to AST to IR to machine code. I built most of this in between sessions at RubyConf 2024 so I decided it was a "feature lite" version of Ruby.

## Who Would Do Such a Thing?

[Dave Schwantes](https://github.com/dorkrawk).

But a lot of the scanner and parser are based on chapters from [Crafting Interpreters](https://craftinginterpreters.com/) by Robert Nystrom.
