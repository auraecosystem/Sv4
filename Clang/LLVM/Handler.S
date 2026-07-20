# Function Signature: int64_t dot_product(const int32_t *A, const int32_t *B, size_t len)
# Input Registers: a0 = base address A, a1 = base address B, a2 = length of vectors
# Output Registers: a0 (lower 32-bits), a1 (upper 32-bits) -> forming a 64-bit int

.global dot_product
.text
.align 2

dot_product:
    li      t0, 0           # t0 = Accumulator Low (64-bit total result)
    li      t1, 0           # t1 = Accumulator High
    li      t2, 0           # t2 = Current loop counter index (i = 0)

loop_start:
    bge     t2, a2, loop_end # If i >= len, break loop execution branch

    # Load 32-bit signed integers from source array pointers
    lw      t3, 0(a0)       # t3 = A[i]
    lw      t4, 0(a1)       # t4 = B[i]

    # --- RISC-V M Extension Core Execution Block ---
    mul     t5, t3, t4      # t5 = Lower 32-bits of product (A[i] * B[i])
    mulh    t6, t3, t4      # t6 = Upper 32-bits of product (Signed)

    # 64-bit Accumulation Phase (Adding t6:t5 to t1:t0)
    add     t0, t0, t5      # Accumulate lower 32-bit bound
    sltu    t5, t0, t5      # Carry check: set t5=1 if an overflow occurred
    add     t1, t1, t6      # Accumulate upper 32-bit bound
    add     t1, t1, t5      # Apply the lower carry bit to the upper register

    # Increment memory base pointers and loop index counters
    addi    a0, a0, 4       # Advance vector A pointer by 4 bytes (sizeof(int32_t))
    addi    a1, a1, 4       # Advance vector B pointer by 4 bytes
    addi    t2, t2, 1       # i++
    j       loop_start

loop_end:
    mv      a0, t0          # Place lower 32-bit result into return register a0
    mv      a1, t1          # Place upper 32-bit result into return register a1
    ret                     # Return control to calling program
