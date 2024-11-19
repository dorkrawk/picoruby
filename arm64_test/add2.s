.global _main             // Define the global entry point for macOS
.align 2                  // Ensure 4-byte alignment (2^2 = 4 bytes)

_main:
    MOV X0, #3           // Load the immediate value 3 into register X0
    MOV X1, #4           // Load the immediate value 4 into register X1
    ADD X2, X0, X1       // Add X0 and X1, store the result (7) in X2

    MOV X0, #5
    ADD X2, X0, X2

    // macOS expects the return value in X0 when main exits
    MOV X0, X2           // Move the result (7) into X0 as the return value
    RET                  // Return from _main, ending the program
