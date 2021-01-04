    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $f000       ; Defines the origin of the ROM at $F000

Start:
    CLEAN_START     ; Macro to safely clear the memory

    ldx #$80        ; blue background
    stx COLUBK

    lda #$51C
    sta COLUPF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start a new frame by turning on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:
    lda #2              ; same as binary value %00000010
    sta VBLANK          ; turn on VBLANK
    sta VSYNC           ; turn on VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 3
        sta WSYNC       ; three scanlines for VSYNC
    REPEND

    lda #0
    sta VSYNC           ; turn off VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Let the TIA output the recommended 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 37
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK          ; turn of VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw 192 visible scanline (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #192            ; counter for 192 visible scanlines
LoopVisible:
    stx COLUBK          ; set the background color
    sta WSYNC           ; wait for the next scanline
    dex                 ; X--
    bne LoopVisible     ; loop while X != 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Output 30 more VBLANK lines (overscan) to complete our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2              ; hit and turn on VBLANK again
    sta VBLANK     

    ldx #30             ; counter for 30 scanlines
LoopOVerscan:
    sta WSYNC           ; wait for the next scanline
    dex                 ; X--
    bne LoopOVerscan    ; loop

    jmp NextFrame


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC       ; Defines origin to $FFFC
    .word Start     ; Reset vector at $FFC (where program start)
    .word Start     ; Interrupt vector at $FFFE (unuse in the VCS)