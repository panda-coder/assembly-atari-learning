    processor 6502
    
    seg code
    org $F000   ; Define the code origin at $F000

Start:
    sei         ; Disable interrupts
    cld         ; Disable the BCD decimal math mode
    ldx #$FF    ; Loads the X register with #$FF
    txs         ; Transfer the X register to the (S)tack pointer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear te Page Zero region ($00 to $FF)
; Meaning the entire RAM and also the entire TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #0      ; A = 0
    ldx #$FF    ; X = #$FF
MemLoop:
    sta $0,X    ; Store the value of A inside memory address $0 - X
    dex         ; X--
    bne MemLoop ; Lopp until X is equal to zero (z-flag is set)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill the ROM size to exactle 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    .word Start  ; Reset vector at $FFFC ( there the program starts )
    .word Start  ; Interrupt vector at $FFFE (unused the VCS)