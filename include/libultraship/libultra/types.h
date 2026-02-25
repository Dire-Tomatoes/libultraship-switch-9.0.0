#ifndef ULTRA64_TYPES_H
#define ULTRA64_TYPES_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

typedef signed char s8;
typedef unsigned char u8;
typedef signed short int s16;
typedef unsigned short int u16;
typedef signed int s32;
typedef unsigned int u32;
// On aarch64 (Switch), uint64_t is "unsigned long int" while "unsigned long long int"
// is a distinct type. libnx's <switch/types.h> also typedefs u64/s64 using uint64_t/int64_t,
// so we must match to avoid conflicting typedef errors.
#ifdef __SWITCH__
typedef int64_t s64;
typedef uint64_t u64;
#else
typedef signed long long int s64;
typedef unsigned long long int u64;
#endif

typedef volatile u8 vu8;
typedef volatile u16 vu16;
typedef volatile u32 vu32;
typedef volatile u64 vu64;
typedef volatile s8 vs8;
typedef volatile s16 vs16;
typedef volatile s32 vs32;
typedef volatile s64 vs64;

typedef float f32;
typedef double f64;
#if 0

typedef s32 ptrdiff_t;
typedef s32 intptr_t;
typedef u32 uintptr_t;
#endif

typedef int Mtx_t[4][4];
typedef union {
    Mtx_t m;
    struct {
        u16 intPart[4][4];
        u16 fracPart[4][4];
    };
    long long int forc_structure_alignment;
} MtxS;

typedef float MtxF_t[4][4];
typedef union {
    MtxF_t mf;
    struct {
        float xx, yx, zx, wx, xy, yy, zy, wy, xz, yz, zz, wz, xw, yw, zw, ww;
    };
} MtxF;

#ifndef GBI_FLOATS
typedef MtxS Mtx;
#else
typedef MtxF Mtx;
#endif

#endif
