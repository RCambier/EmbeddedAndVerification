
    #include <brick-unittest.h>
    
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/buchi.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/die.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/meta.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/output.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/report.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/statistics.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/strings.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/sysinfo.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/version.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/utility/withreport.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/barrier.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/blob.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/lens.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/list.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/mpi.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/ntreehashset.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/parallel.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/pool.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/toolkit/rpc.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/cesmi.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/coin.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/common.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/dummy.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/dve.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/explicit.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/llvm.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/generator/timed.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/common.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/csdr.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/genexplicit.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/map.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/metrics.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/nested-dfs.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/owcty.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/por-c3.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/reachability.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/algorithm/simulate.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/explicit/explicit.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/explicit/header.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/explicit/transpose.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/llvm/silk-eval.h>
#include </Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine/llvm/silk-parse.h>
    int main( int argc, const char **argv ) {
      
      return brick::unittest::run( argc > 1 ? argv[1] : "",
                                   argc > 2 ? argv[2] : "" );
      return 0;
    }