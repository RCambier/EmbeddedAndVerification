/* funlockfile(FILE * )

   This file is part of the Public Domain C Library (PDCLib).
   Permission is granted to use, modify, and / or redistribute at will.
*/

#include <stdio.h>
#include <stdarg.h>

#ifndef REGTEST
#include <_PDCLIB_io.h>
#include <threads.h>
#include <stdlib.h>

void _PDCLIB_funlockfile( FILE * file )
{
    int res = mtx_unlock( &file->lock );
    switch(res) {
        case thrd_success:
            return;

        default:
            abort();
    }
}

#endif

#ifdef TEST
#include <_PDCLIB_test.h>

int main( void )
{
    // Not tested here - tested by other stdio test drivers
    return TEST_RESULTS;
}

#endif
