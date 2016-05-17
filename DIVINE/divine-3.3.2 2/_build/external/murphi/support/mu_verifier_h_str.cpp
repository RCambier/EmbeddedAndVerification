namespace murphi { const char *mu_verifier_h_str = "\
/* -*- C++ -*-\n\
 * mu_verifier.h\n\
 * @(#) common information used by the generated code of Murphi verifiers\n\
 *      and supporting codes. \n\
 *\n\
 * Copyright (C) 1992 - 1999 by the Board of Trustees of              \n\
 * Leland Stanford Junior University.\n\
 *\n\
 * License to use, copy, modify, sell and/or distribute this software\n\
 * and its documentation any purpose is hereby granted without royalty,\n\
 * subject to the following terms and conditions:\n\
 *\n\
 * 1.  The above copyright notice and this permission notice must\n\
 * appear in all copies of the software and related documentation.\n\
 *\n\
 * 2.  The name of Stanford University may not be used in advertising or\n\
 * publicity pertaining to distribution of the software without the\n\
 * specific, prior written permission of Stanford.\n\
 *\n\
 * 3.  This software may not be called \"Murphi\" if it has been modified\n\
 * in any way, without the specific prior written permission of David L.\n\
 * Dill.\n\
 *\n\
 * 4.  THE SOFTWARE IS PROVIDED \"AS-IS\" AND STANFORD MAKES NO\n\
 * REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, BY WAY OF EXAMPLE,\n\
 * BUT NOT LIMITATION.  STANFORD MAKES NO REPRESENTATIONS OR WARRANTIES\n\
 * OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE\n\
 * USE OF THE SOFTWARE WILL NOT INFRINGE ANY PATENTS, COPYRIGHTS\n\
 * TRADEMARKS OR OTHER RIGHTS. STANFORD SHALL NOT BE LIABLE FOR ANY\n\
 * LIABILITY OR DAMAGES WITH RESPECT TO ANY CLAIM BY LICENSEE OR ANY\n\
 * THIRD PARTY ON ACCOUNT OF, OR ARISING FROM THE LICENSE, OR ANY\n\
 * SUBLICENSE OR USE OF THE SOFTWARE OR ANY SERVICE OR SUPPORT.\n\
 *\n\
 * LICENSEE shall indemnify, hold harmless and defend STANFORD and its\n\
 * trustees, officers, employees, students and agents against any and all\n\
 * claims arising out of the exercise of any rights under this Agreement,\n\
 * including, without limiting the generality of the foregoing, against\n\
 * any damages, losses or liabilities whatsoever with respect to death or\n\
 * injury to person or damage to property arising from or out of the\n\
 * possession, use, or operation of Software or Licensed Program(s) by\n\
 * LICENSEE or its customers.\n\
 *\n\
 * Read the file \"license\" distributed with these sources, or call\n\
 * Murphi with the -l switch for additional information.\n\
 *\n\
 *\n\
 */\n\
\n\
/* \n\
 * Original Author: Ralph Melton\n\
 * Extracted from mu_epilog.inc and mu_prolog.inc\n\
 * by C. Norris Ip\n\
 * Created: 21 April 93\n\
 *\n\
 * Update:\n\
 *\n\
 */ \n\
\n\
/****************************************\n\
  Include library\n\
 ****************************************/\n\
\n\
#include <stdlib.h>\n\
#include <stdio.h>\n\
#include <string.h>\n\
#include <stdarg.h>\n\
#include <iostream>\n\
//#include <values.h> /* for BITSPERBYTE and BITS() */\n\
// Uli: values.h is obsolete, replaced by limits.h\n\
#include <limits.h>\n\
#include <new>    /* for new_handler stuff. */\n\
#include <signal.h> /* To trap division by zero. */\n\
#include <assert.h>\n\
#include <vector>\n\
\n\
\n\
/****************************************   // added by Uli\n\
  C Objects\n\
 ****************************************/\n\
\n\
extern \"C\" int remove(const char *filename);\n\
\n\
\n\
/****************************************\n\
  General Constants\n\
 ****************************************/\n\
\n\
#define FALSE 0\n\
#define TRUE 1\n\
#define mu_false 0\n\
#define mu_true 1\n\
#define BIT_BLOCK unsigned char /* type of an element for a bit vector. */\n\
\n\
// Uli: replace the BITS() macro from values.h\n\
#ifndef BITS\n\
#define BITS(type) ((int)sizeof (type) * CHAR_BIT)\n\
#endif\n\
\n\
//typedef char bool;\n\
typedef void (*proc) (void);\n\
typedef bool (*boolfunc) (void);\n\
\n\
\n\
struct rulerec {\n\
  char *name;\n\
  boolfunc condition;\n\
  proc code;\n\
  bool unfair;\n\
};\n\
\n\
#ifndef ALIGN\n\
typedef struct {\n\
  int longoffset;   /* offset in the state vector, on long boundary */\n\
  unsigned int mask1, mask2;  /* masks for fast access */\n\
  int shift1, shift2;         /* shift values for fast access */\n\
} position;\n\
#endif\n\
\n\
/****************************************\n\
  For Liveness\n\
 ****************************************/\n\
enum space { PRE, LEFT, RIGHT };\n\
enum live_type { E, AE, EA, U, AIE, AIU };\n\
struct liverec {\n\
  char *name;\n\
  boolfunc condition_pre;\n\
  boolfunc condition_left;\n\
  boolfunc condition_right;\n\
  live_type livetype;\n\
};\n\
\n\
\n\
/****************************************\n\
  class declaration\n\
 ****************************************/\n\
\n\
// declared in mu_util.h\n\
class mu__int;      /* a base for a value */\n\
class mu_boolean;   /* a base for a boolean */\n\
class world_class;  /* class for variables in expanded state */\n\
class state_queue;  /* class for search queue for bfs */\n\
class state_stack;  /* class for search queue for dfs */\n\
class state_set;    /* hash table for storing state examined */\n\
\n\
// declared in mu_io.h\n\
class Error_handler;/* class for error handling */\n\
class argclass;     /* class for handling command line argument */\n\
\n\
// declared in here\n\
class dynBitVec;    /* class for bit vector , state */\n\
\n\
// declared in mu_dep.h\n\
class state;        /* a state in the state graph -- a bit vector */\n\
class state_L;      /* a state in the state graph for liveness -- with more info */\n\
class setofrules;   /* class to store a set of rules */\n\
class sleepset;     /* sleepset for partial order reduction technique */\n\
class rule_matrix;  /* class for square matrix of dimension numrules */\n\
\n\
/****************************************\n\
  external variables\n\
 ****************************************/\n\
\n\
// from murphi code\n\
// extern const rulerec rules[];\n\
extern const unsigned numrules;   // Uli: unsigned short -> unsigned\n\
extern const rulerec startstates[];\n\
extern const unsigned short numstartstates;\n\
extern const rulerec invariants[];\n\
extern const unsigned short numinvariants;\n\
extern const rulerec fairnesses[];\n\
extern const unsigned short numfairnesses;\n\
extern const liverec livenesses[];\n\
extern const unsigned short numlivenesses;\n\
\n\
#define STARTSTATE 0\n\
#define CONDITION 1\n\
#define RULE 2\n\
#define INVARIANT 3\n\
\n\
class StartStateManager;\n\
class RuleManager;\n\
class PropertyManager;\n\
class StateManager;\n\
class SymmetryManager;\n\
class POManager;\n\
class ReportManager;\n\
class AlgorithmManager;\n\
\n\
extern StartStateManager *StartState;  // manager for all startstate related operation\n\
extern RuleManager *Rules;             // manager for all rule related operation\n\
extern PropertyManager *Properties;    // manager for all property related operation\n\
extern StateManager *StateSet;         // manager for all state related information\n\
extern SymmetryManager *Symmetry;      // manager for all symmetry information\n\
extern POManager *PO;                  // manager for all symmetry information\n\
extern ReportManager *Reporter;        // manager for all diagnostic messages\n\
extern AlgorithmManager *Algorithm;    // manager for all algorithm related issue\n\
\n\
extern Error_handler Error;       // general error handler.\n\
extern argclass *args;            // the record of the arguments.\n\
// extern state *curstate;        // current state at the beginning of the rule-firing\n\
// extern state *const workingstate;   // Uli: this pointer points to a working-\n\
                                    //      buffer\n\
// extern world_class theworld;          // the set of global variables.\n\
extern int category;                  // working on startstate, rule or invariant\n\
\n\
struct NextStateGenerator;\n\
struct StartStateGenerator;\n\
struct MuGlobalVars;\n\
struct SymmetryClass;\n\
\n\
struct MuGlobal {\n\
    static bool initialised;\n\
    static pthread_mutex_t mutex;\n\
    static MuGlobal &get();\n\
    static bool init_once( int ac, char **av );\n\
\n\
public:\n\
    state *working;\n\
    world_class *world;\n\
    StartStateGenerator *startgen;\n\
    NextStateGenerator *nextgen;\n\
    Error_handler *error;\n\
    MuGlobalVars *variables;\n\
    SymmetryClass *symmetry;\n\
\n\
    MuGlobal();\n\
};\n\
\n\
pthread_mutex_t MuGlobal::mutex = PTHREAD_MUTEX_INITIALIZER;\n\
bool MuGlobal::initialised = false;\n\
\n\
#define workingstate (MuGlobal::get().working)\n\
#define theworld (*MuGlobal::get().world)\n\
\n\
template< typename T >\n\
struct PerThread {\n\
    T initial;\n\
    int i;\n\
\n\
    T &get() {\n\
        static __thread std::vector< T > *x = 0;\n\
        if (!x)\n\
            x = new std::vector< T >;\n\
        if (x->size() <= i)\n\
            x->resize( i + 1, initial );\n\
        return (*x)[i];\n\
    }\n\
\n\
    PerThread( const T &ini = T() )\n\
        : initial( ini )\n\
    {\n\
        static __thread int last_i = 0;\n\
        i = ++last_i;\n\
    }\n\
};\n\
\n\
/****************************************\n\
  * 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
  * 12 April 94 Norris Ip:\n\
  add information about error in the condition of the rules\n\
  category = CONDITION\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_verifier.h,v $\n\
  Revision 1.2  1999/01/29 07:49:11  uli\n\
  bugfixes\n\
\n\
  Revision 1.4  1996/08/07 18:54:33  ip\n\
  last bug fix on NextRule/SetNextEnabledRule has a bug; fixed this turn\n\
\n\
  Revision 1.3  1996/08/07 01:00:18  ip\n\
  Fixed bug on what_rule setting during guard evaluation; otherwise, bad diagnoistic message on undefine error on guard\n\
\n\
  Revision 1.2  1996/08/07 00:15:26  ip\n\
  fixed while code generation bug\n\
\n\
  Revision 1.1  1996/08/07 00:14:46  ip\n\
  Initial revision\n\
\n\
********************/\n\
"; }
