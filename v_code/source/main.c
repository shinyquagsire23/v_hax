#include "imports.h"

void _main()
{
    // ghetto dcache invalidation
    // don't judge me
    for(int j = 0; j < sizeof(u32); j++)
        for(int i = 0; i < 0x01000000 / sizeof(u32); i += sizeof(u32))
            LINEAR_BUFFER[i + j] ^= 0x56;

    // run payload
    {
        void (*payload)(u32* paramlk, u32* stack_pointer) = (void*)0x00101000;
        u32* paramblk = (u32*)LINEAR_BUFFER;

        paramblk[0x1c >> 2] = V_GSPGPU_GXCMD4;
        paramblk[0x20 >> 2] = V_GSPGPU_FLUSHDATACACHE_WRAPPER;
        paramblk[0x48 >> 2] = 0x8d; // flags
        paramblk[0x58 >> 2] = V_GSPGPU_HANDLE;
        paramblk[0x64 >> 2] = 0x08010000;

        payload(paramblk, (u32*)(0x10000000 - 4));
    }
}
