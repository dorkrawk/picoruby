.global _main             // Define the global entry point for macOS
.align 2                  // Ensure 4-byte alignment (2^2 = 4 bytes)

_main:
    MOV X0, #42           // Load the immediate value 42 into register X0

    // macOS expects the return value in X0 when main exits
    MOV X0, X0           // Move the result (42) into X0 as the return value (we could get rid of this)
    RET                  // Return from _main, ending the program
