namespace murphi { const char *mu_verifier_C_str = "\
/* -*- C++ -*-\n\
 * mu_verifier.C\n\
 * @(#) Main routines for the driver for Murphi verifiers.\n\
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
 * \n\
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
  There are 3 groups of implementations:\n\
  None of them belong to any class\n\
  1) verifying invariants\n\
  2) transition sets generation\n\
  3) verification and simulaiton supporting routines\n\
  4) BFS algorithm supporting -- generate next stateset\n\
  5) BFS algorithm main routine\n\
  6) DFS algorithm main routine\n\
  7) simulation\n\
  8) global variables\n\
  9) main function\n\
  ****************************************/\n\
\n\
\n\
/****************************************\n\
  Global variables:\n\
  void set_up_globals(int argc, char **argv)\n\
  ****************************************/\n\
\n\
// why exists? (Norris)\n\
// saved value for the old new handler.\n\
// void (*oldnh)() = NULL;       \n\
\n\
bool MuGlobal::init_once( int ac, char **av ) {\n\
    pthread_mutex_lock( &mutex );\n\
    if ( initialised ) {\n\
        pthread_mutex_unlock( &mutex );\n\
        return false;\n\
    }\n\
    initialised = true;\n\
    args = new argclass( ac, av );\n\
    pthread_mutex_unlock( &mutex );\n\
    return true;\n\
}\n\
\n\
/****************************************\n\
  The Main() function:\n\
  int main(int argc, char **argv)\n\
  ****************************************/\n\
\n\
#if 0\n\
int main(int argc, char **argv)\n\
{\n\
  args = new argclass(argc, argv);\n\
  Algorithm = new AlgorithmManager();\n\
\n\
//   if ( args->debug_sym.value )\n\
//     {\n\
//       verify_bfs_standard();\n\
//       print_no_error();\n\
//       print_summary();\n\
// \n\
//       // copy_hashtable();\n\
//       debug_sym_the_states = new state_set;\n\
//       copy_state_set(debug_sym_the_states, the_states);\n\
//       the_states->clear_state_set();\n\
// \n\
//       args->symmetry_reduction.reset(TRUE);\n\
//       verify_bfs_standard();\n\
//       print_no_error();\n\
//       print_summary();\n\
//       if (args->print_hash.value)\n\
// 	print_hashtable();\n\
//     } \n\
//   else\n\
  if ( args->main_alg.mode == argmain_alg::Verify_bfs )\n\
    {\n\
      Algorithm->verify_bfs();\n\
    }\n\
  else if ( args->main_alg.mode == argmain_alg::Verify_dfs )\n\
    {\n\
      Algorithm->verify_dfs();\n\
    }\n\
  else if ( args->main_alg.mode == argmain_alg::Simulate )\n\
    {\n\
      Algorithm->simulate();\n\
    }\n\
\n\
  cout.flush();\n\
#ifdef HASHC\n\
  if (args->trace_file.value)\n\
    delete TraceFile;\n\
#endif\n\
  exit(0);\n\
}\n\
#endif\n\
\n\
/****************************************\n\
  * 8 Feb 94 Norris Ip:\n\
  add print hashtable for debugging\n\
  * 24 Feb 94 Norris Ip:\n\
  added -debugsym option to run two hash tables in parallel\n\
  for debugging purpose\n\
  * 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
  * 12 April 94 Norris Ip:\n\
  add information about error in the condition of the rules\n\
  category = CONDITION\n\
  * 14 April 94 Norris Ip:\n\
  fixed simlution mode printing when -h is used\n\
  * 14 April 94 Norris Ip:\n\
  change numbering of symmetry algorithms\n\
  * 14 April 94 Norris Ip:\n\
  fixed the number of digit in time output\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_verifier.C,v $\n\
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
