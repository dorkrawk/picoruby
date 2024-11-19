# Assemble, Link, and Run

system("as -o add.o add.s") # assemble the program
system("clang -o add add.o -Wl,-e,_main") # link it
system("./add; echo $?") # run it! and echo it!
