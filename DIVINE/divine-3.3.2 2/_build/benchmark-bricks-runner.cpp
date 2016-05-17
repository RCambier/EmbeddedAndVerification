
    #include <brick-benchmark.h>
    
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-assert.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-benchmark.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-bitlevel.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-commandline.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-data.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-fs.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-gnuplot.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-hash.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-hashset.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-hlist.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-llvm.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-mmap.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-parse.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-process.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-query.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-rpc.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-shelltest.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-shmem.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-string.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-tuple.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-types.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/bricks/brick-unittest.h>
    int main( int argc, const char **argv ) {
      brick::benchmark::run( argc, argv );
      return 0;
    }