#ifndef IMPORTS_H
#define IMPORTS_H

#include <3ds/types.h>

#include "../../constants/constants.h"
#define LINEAR_BUFFER ((u8*)0x14100000)

// handles
static Handle* const srvHandle = (Handle*)V_SRV_HANDLE;
static Handle* const fsHandle = (Handle*)V_FSUSER_HANDLE;
static Handle* const dspHandle = (Handle*)V_DSPDSP_HANDLE;
static Handle* const gspHandle = (Handle*)V_GSPGPU_HANDLE;

// buffers
static u32** const sharedGspCmdBuf = (u32**)(V_GSPGPU_INTERRUPT_RECEIVER_STRUCT + 0x58);

// functions
static Result (* const _GSPGPU_FlushDataCache)(Handle* handle, Handle kprocess, u32* addr, u32 size) = (void*)V_GSPGPU_FLUSHDATACACHE;
static Result (* const _GSPGPU_GxTryEnqueue)(u32** sharedGspCmdBuf, u32* cmdAdr) = (void*)V_GSPGPU_GXTRYENQUEUE;
static Result (* const _FSUSER_OpenFileDirectly)(Handle* handle, Handle* fileHandle, u32 transaction, u32 archiveId, u32 archivePathType, char* archivePath, u32 archivePathLength, u32 filePathType, char* filePath, u32 filePathLength, u8 openflags, u32 attributes) = (void*)V_FSUSER_OPENFILEDIRECTLY;
static Result (* const _FSUSER_OpenFile)(Handle* handle, Handle* fileHandle, u32 transaction, int unk, u64 archiveHandle, u32 filePathType, char* filePath, u32 filePathLength, u8 openflags, u32 attribute) = (void*)V_FSUSER_OPENFILE;
static Result (* const _FSUSER_ReadFile)(Handle* handle, u32* bytesRead, s64 offset, void *buffer, u32 size) = (void*)V_FSFILE_READ;
static Result (* const _DSP_UnloadComponent)(Handle* handle) = (void*)V_DSPDSP_UNLOADCOMPONENT;
static Result (* const _DSP_RegisterInterruptEvents)(Handle* handle, Handle event, u32 type, u32 port) = (void*)V_DSPDSP_REGISTERINTERRUPTEVENTS;

#endif
