#include <stdint.h>
#include <stdio.h>
#include <math.h>

#include "image.h"

#ifdef FLOAT_PERM
    typedef float perm_prec;
#endif

#ifdef FLOAT_DIFF
    typedef float diff_prec;
#endif

#ifdef DOUBLE_PERM
    typedef double perm_prec;
#endif

#ifdef DOUBLE_DIFF
    typedef double diff_prec;
#endif

#define _MU_PERM_ MU_PERM
#define _MU_DIFF_ MU_DIFF

#define _DT_  DT

#define HEIGHT _H
#define WIDTH  _W

#define BSIZE HEIGHT*WIDTH

#define _CIPHER_EXPR_  CEXPR

#define MOD std::modf
#define NORM 1.0
#define NORM_2 2.0
#define ABS std::fabs
#define POW std::pow

struct str
{
    perm_prec value;
    int index;
};