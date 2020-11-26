    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $f000       ; Defines the origin of the ROM at $F000

Start:
    CLEAN_START     ; Macro to safely clear the memory

LoopBackground:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set backgroun luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #$1E        ; Load color into A ($1E is NTSC yellow)
    sta COLUBK      ; store A to BackgroundColor Address $09

    jmp LoopBackground       ; Repeat from start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC       ; Defines origin to $FFFC
    .word Start     ; Reset vector at $FFC (where program start)
    .word Start     ; Interrupt vector at $FFFE (unuse in the VCS)