namespace murphi { const char *mu_io_C_str = "\
/* -*- C++ -*-\n\
 * mu_io.C * @(#) interface routines for the driver for Murphi verifiers.\n\
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
  There are 4 groups of implementations:\n\
  0) local #define switches\n\
  1) Error_handler class implementation\n\
  2) argclass implementation\n\
  3) general printing routine (not belong to any class)\n\
  4) trace info file\n\
  \n\
  to set default options, set parameter at\n\
  argclass::argclass(...)\n\
  ****************************************/\n\
\n\
/****************************************\n\
  #defines for switches to the program.\n\
  ****************************************/\n\
\n\
#include <ctype.h>\n\
\n\
// General\n\
#define HELP_FLAG       \"-h\"    /* for help list. */\n\
#define LICENSE_FLAG \"-l\"    /*  print license. */\n\
\n\
// Verification Strategy\n\
#define SIMULATE_FLAG   \"-s\"    /* simulate instead of verifying. */\n\
#define VERIFY_FLAG     \"-v\"    /* verify with breadth-first search. */\n\
#define VERIFY_BFS_FLAG \"-vbfs\" /* Ditto. */\n\
#define VERIFY_DFS_FLAG \"-vdfs\" /* verify with depth-first search. */\n\
\n\
// main options\n\
#define MEM_MEG_PREFIX  \"-m\"    /* Memory allotment in Meg. */\n\
#define MEM_K_PREFIX    \"-k\"    /* Memory allotment in K. */\n\
#define LOOPMAX_PREFIX  \"-loop\" /* number of times you can go around a loop. */\n\
\n\
// progress\n\
#define VERBOSE_FLAG    \"-p\"    /* Print every time, with lots of detail. */\n\
#define PRINT_10_FLAG   \"-p1\"   /* Print progress reports every ten events. */\n\
#define PRINT_100_FLAG  \"-p2\"   /* Print every hundred. */\n\
#define PRINT_1000_FLAG \"-p3\"   /* Print every thousand. */\n\
#define PRINT_10000_FLAG \"-p4\"  /* Every ten thousand. */\n\
#define PRINT_100000_FLAG \"-p5\" /* Guess, just guess. */\n\
#define PRINT_NONE_FLAG  \"-pn\"  /* Don't print progress reports at all. */\n\
\n\
// error detection\n\
#define NO_DEADLOCK_FLAG \"-ndl\" /* verify without deadlock checking */\n\
#define CONTINUE_AFTER_ERROR_FLAG \"-finderrors\" /* verify without stopping at error */\n\
#define MAX_NUM_ERRORS_PREFIX \"-errorsmax\" /* verify without stopping at error */\n\
\n\
// error trace handling\n\
#define TRACE_VIOLATE_FLAG \"-tv\"/* Print a violating trace. */\n\
#define TRACE_DIFF_FLAG  \"-td\" /* Print state differences instead of full states. */\n\
#define TRACE_FULL_FLAG \"-tf\"   /* print full states in traces. */\n\
#define TRACE_ALL_FLAG  \"-ta\"   /* Print traces containing all states. */\n\
#define TRACE_NONE_FLAG \"-tn\"   /* no traces. */\n\
\n\
// #define TRACE_LONGEST_FLAG \"-tl\"/* Print the longest trace. */\n\
// I don\\'t know that -tl is for (Norris)\n\
\n\
// analysis of state space\n\
#define PRINT_RULE_FLAG \"-pr\"   /* Print out rule information. */\n\
#define PRINT_HASH_FLAG \"-ph\"   /* Print out hash table. */\n\
// #define PRINT_STATE_FLAG \"-ps\"  /* \"Print start, progress, and final state. \"*/\n\
\n\
// symmetry\n\
#define NO_SYM_FLAG \"-nosym\"      /* do not use symmmetry reduction technique */\n\
#define SYMMETRY_PREFIX \"-sym\"    /* use symmetry reduction technique */\n\
#define NO_MULTISET_FLAG \"-nomultiset\"    /* do not use multiset reduction technique */\n\
#define PERM_LIMIT \"-permlimit\"   /* maximum number of permutations wasted on canon */\n\
\n\
// debug symmetry\n\
#define TEST1_PREFIX \"-testa\"     /* use to enter testing parameter */\n\
#define TEST2_PREFIX \"-testb\"     /* use to enter testing parameter */\n\
#define DEBUG_SYM_FLAG \"-debugsym\"     /* use to enter testing parameter */\n\
\n\
// Uli: hash compaction options\n\
#ifdef HASHC\n\
#define NUM_BITS_PREFIX     \"-b\"     // number of bits to store\n\
#define TRACE_DIR_PREFIX    \"-d\"     // directory for error trace info file\n\
#endif\n\
\n\
// just for your information\n\
#define DEFAULT_FLAGS   VERIFY_FLAG PRINT_100_FLAG TRACE_VIOLATE_FLAG\n\
\n\
/****************************************\n\
  Implementation for the Error class.\n\
  ****************************************/\n\
\n\
// make sure that you have executed fflush(stdout) when\n\
// you change from printf to cout, and cout.flush() when\n\
// you change from cout to printf.\n\
\n\
// on second thought, I am rewriting everything to only use cout.\n\
// We may well be placing ourselves wholly within the hands of\n\
// flaky ostreams, but we won\\'t have weirdnesses with not flushing\n\
// things properly. RLM 7/23/93\n\
\n\
void Error_handler::Error( const char *fmt... )\n\
{\n\
  // Uli: assumptions: \n\
  // - curstate points to the state whose successors are currently being\n\
  //  generated\n\
  // - NumCurState is set to the number of curstate in the trace info file\n\
  // - curstate may not point to workingstate buffer\n\
  // - an error occurred during the generation of one of the successors\n\
  // - for startstates: what_startstate is set correctly\n\
 \n\
  // we regenerate the trace; this is necessary\n\
  // with symmetry extension, since\n\
  // [s1] -[a]-> [s2] in the hash table does not imply s1-a->s2\n\
\n\
  // there are two phases for error reporting with trace printing\n\
  // phase 1) first call to Error(...); error detected and regenerate\n\
  //          trace from the rules recorded in state set.\n\
  //          print trace until the last state\n\
  // phase 2) second call to Error(...); error detected again when \n\
  //          regenerate the error state; print the last state and\n\
  //          print summary \n\
\n\
  // Uli: in simulation mode call \"notrace\" version\n\
  // if (args->main_alg.mode==argmain_alg::Simulate)\n\
  {\n\
    cout << \"\\nStatus:\\n\\n\";\n\
    cout << \"\\t\" << Rules->NumRulesFired() \n\
         << \" rules fired in simulation in \"\n\
         << SecondsSinceStart() << \"s.\\n\";\n\
    Notrace(fmt);\n\
  }\n\
\n\
  static int phase = 1;\n\
\n\
  //  unsigned last_rule = what_rule;   // Uli: unsigned short -> unsigned\n\
  \n\
  // set up error statement in buffer.\n\
  va_list argp;\n\
  va_start ( argp, fmt);\n\
  vsprintf(buffer,fmt,argp);\n\
  va_end(argp);\n\
  \n\
  if (args->print_trace.value)\n\
    {\n\
      // please print trace\n\
\n\
      if (curstate == NULL)\n\
	{\n\
	  // Error when generating startstate\n\
\n\
	  // header\n\
	  cout << \"\\nThe following is the error occured during the construction of a startstate:\\n\\n\\t\";\n\
	  cout << buffer << \"\\n\\n\";\n\
\n\
	  // print fragment of startstate created so far\n\
	  cout << \"Fragment of startstate \"\n\
	       << StartState->LastStateName()\n\
	       << \" obtained when the error is found is:\\n\";\n\
	  theworld.print();\n\
	  cout << \"----------\\n\\n\";\n\
	  \n\
	}\n\
      else\n\
	{\n\
	  // Error when firing the rule \"what_rule\"\n\
	  // spit into two phases Error reporting\n\
	  \n\
	  if (phase == 1)\n\
	    {\n\
	      // phase 1 of Error reporting with trace\n\
	      phase = 2;\n\
	      \n\
	      // header\n\
	      cout << \"\\nThe following is the error trace for the error:\\n\\n\\t\";\n\
	      cout << buffer << \"\\n\\n\";\n\
	      \n\
	      // print violate trace\n\
	      // the procedure will not return; in fact, it will execute\n\
	      // the same rule again and call Error(...) again and enter\n\
	      // phase 2 of trace generation\n\
	      Reporter->print_trace_with_theworld();\n\
	    }\n\
	  else\n\
	    {\n\
	      // phase 2 of Error reporting with trace\n\
	      \n\
	      if (category == CONDITION)\n\
		{\n\
		  // print last state\n\
		  cout << \"Guard of the rule\\n\\t\"\n\
		       << Rules->LastRuleName()\n\
		       << \"\\nchecked and caused Error.\\n\";\n\
		  cout << \"----------\\n\\n\";\n\
		}\n\
	      else\n\
		{\n\
		  // print last state\n\
		  cout << \"Rule \"\n\
		       << Rules->LastRuleName()\n\
		       << \" fired.\\n\";\n\
		  cout << \"The last state of the trace (in full) is:\\n\";\n\
		  theworld.print();\n\
		  cout << \"----------\\n\\n\";\n\
		}\n\
\n\
	    }\n\
	}\n\
      \n\
      // print end of trace\n\
      cout << \"End of the error trace.\\n\";\n\
\n\
    }	      \n\
\n\
  // section separator \n\
  cout << \"\\n=====================================\"\n\
       << \"=====================================\\n\"; \n\
\n\
  // print summary of result\n\
  cout << \"\\nResult:\\n\\n\\t\";\n\
  cout << buffer << '\\n';\n\
  Reporter->print_summary(FALSE);\n\
  cout.flush();\n\
#ifdef HASHC\n\
  if (TraceFile!=NULL)\n\
    delete TraceFile;\n\
#endif\n\
  exit(1);\n\
}\n\
\n\
void Error_handler::Deadlocked( const char *fmt... )\n\
{\n\
  // Uli: assumptions:\n\
  // - curstate points to the state that exposes the error\n\
  // - NumCurState is set to the number of the error state in the trace \n\
  //  info file\n\
  // - curstate may not point to workingstate buffer\n\
\n\
  // set up error statement fmt in argp.\n\
  va_list argp;\n\
  va_start ( argp, fmt);\n\
  vsprintf(buffer, fmt, argp);\n\
  va_end (argp);\n\
  \n\
  // print violate trace\n\
  if (args->print_trace.value)\n\
    {\n\
      // header\n\
      cout << \"\\nThe following is the error trace for the error:\\n\\n\\t\";\n\
      cout << buffer << \"\\n\\n\";\n\
\n\
      // trace\n\
      Reporter->print_trace_with_curstate();\n\
\n\
      // print end of trace\n\
      cout << \"End of the error trace.\\n\";\n\
    }\n\
  \n\
  // section separator \n\
  cout << \"\\n=====================================\"\n\
       << \"=====================================\\n\"; \n\
  \n\
  // print summary of result\n\
  cout << \"\\nResult:\\n\\n\\t\";\n\
  cout << buffer << '\\n';\n\
  Reporter->print_summary(FALSE);\n\
  cout.flush();\n\
#ifdef HASHC\n\
  if (TraceFile!=NULL)\n\
    delete TraceFile;\n\
#endif\n\
  exit(1);\n\
}\n\
\n\
void Error_handler::Notrace( const char *fmt... )\n\
{\n\
  // set up error statement fmt in argp.\n\
  va_list argp;\n\
  va_start ( argp, fmt);\n\
  vsprintf( buffer, fmt, argp);\n\
  va_end(argp);\n\
  \n\
  // print error \n\
  cout << \"\\nError:\\n\\n\\t\";\n\
  cout << buffer << \"\\n\\n\";\n\
  va_end(argp);\n\
\n\
  // print progress upto point of error\n\
  if (StateSet != NULL) /* queue has been declared */\n\
    {\n\
      Reporter->print_progress();\n\
      cout << \"\\n\\n\";\n\
    }\n\
  cout.flush();\n\
#ifdef HASHC\n\
  if (TraceFile!=NULL)\n\
    delete TraceFile;\n\
#endif\n\
  exit(1);\n\
}\n\
\n\
/****************************************\n\
  Implementation for the argclass class for handling runtime arguments.\n\
  ****************************************/\n\
\n\
argclass::argclass(int ac, char** av)\n\
: argc(ac), argv(av),\n\
  print_trace     (FALSE, \"trace printing\"),\n\
  full_trace      (FALSE, \"printing diff/full states in trace\"),\n\
  trace_all       (FALSE, \"printing all states\"),\n\
  find_errors     (FALSE, \"continuing after error\"),\n\
  max_errors      (DEFAULT_MAX_ERRORS, \"maximium number of errors\"),\n\
  mem             (DEFAULT_MEM, \"memory allocation\"),\n\
  progress_count  (1000,  \"progress count\"),\n\
  print_progress  (TRUE,  \"progress printing\"),\n\
  main_alg        (argmain_alg::Verify_bfs, \"main algorithm\"),\n\
  loopmax         (DEF_LOOPMAX,\"maximium loop count\"),\n\
  verbose         (FALSE, \"verbose (whether to print out every action\"),\n\
  no_deadlock     (FALSE, \"deadlock detection\"),\n\
  print_options   (FALSE, \"options printing\"),\n\
  print_license   (FALSE, \"license printing\"),\n\
  print_rule      (FALSE, \"rule information printing\"),\n\
  print_hash      (FALSE, \"hashtable information printing\"),\n\
  symmetry_reduction (TRUE, \"symmetry option\"),\n\
  sym_alg         (argsym_alg::Heuristic_Small_Mem_Canonicalize, \"symmetry algorithm\"),\n\
  perm_limit      (10,\"permutation limit\"),\n\
  multiset_reduction (TRUE, \"multiset option\"),\n\
  test_parameter1 (100,\"testing parameter1\"),\n\
  test_parameter2 (100,\"testing parameter2\"),\n\
#ifdef HASHC\n\
  num_bits        (DEFAULT_BITS, \"stored bits\"),   // added by Uli\n\
  trace_file      (FALSE, \"trace info file\"),\n\
#endif\n\
  debug_sym       (FALSE, \"debug symmetry\")\n\
{\n\
  string_iterator *temp = NULL;\n\
  \n\
  temp = new arg_iterator(ac, av);\n\
  ProcessOptions( temp );\n\
  delete temp;\n\
  temp = NULL;\n\
\n\
#ifdef HASHC\n\
  // Uli: do not use trace info file in dfs case\n\
  if (main_alg.mode == argmain_alg::Verify_dfs) {\n\
    if (trace_file.value) {\n\
      delete TraceFile;\n\
      trace_file.reset(FALSE);\n\
    }\n\
  }\n\
\n\
  // Uli: check if trace is wanted but cannot be generated\n\
  if (main_alg.mode == argmain_alg::Verify_bfs)\n\
    if (print_trace.value  && !trace_file.value)\n\
      Error.Notrace\n\
        (\"Cannot print error trace if you do not specify trace info file.\");\n\
\n\
  // Uli: set number of bytes in trace info file\n\
  //      cannot be done earlier since number of bits may be unknown\n\
  if (trace_file.value) {\n\
    TraceFile->setBytes(int(num_bits.value));\n\
    print_trace.reset(TRUE);\n\
  }\n\
#endif\n\
\n\
  // avoid mixing verbose and progress report\n\
  if (verbose.value) print_progress.set(FALSE);\n\
\n\
  if (main_alg.mode != argmain_alg::Verify_bfs && find_errors.value)\n\
  // changed by Uli\n\
    {\n\
      Error.Notrace(\"Please use -vbfs for finding multiple errors in single run.\");\n\
    }\n\
\n\
  if (sym_alg.mode != argsym_alg::Heuristic_Small_Mem_Canonicalize\n\
      && perm_limit.value !=0)\n\
    {\n\
      perm_limit.set(0);\n\
    }\n\
\n\
  if (debug_sym.value) symmetry_reduction.reset(FALSE);\n\
\n\
  PrintInfo();\n\
}\n\
\n\
void argclass::PrintInfo( void )\n\
{\n\
  if (print_license.value) PrintLicense();\n\
  \n\
  cerr << \" NB. Murphi is a DEBUGGING aid, not a \"\n\
       << \"certifier of correctness. :(\\n\";\n\
  // cout.flush();\n\
  \n\
  if (print_options.value) PrintOptions();\n\
}\n\
\n\
void argclass::ProcessOptions(string_iterator *options)\n\
{\n\
  char* option;\n\
  bool no_verification = FALSE;\n\
  unsigned long temp;\n\
  char temp_str[256];\n\
  \n\
  for ( options->start();\n\
	!options->done(); \n\
	options->next()  )\n\
    {\n\
      option = options->value();\n\
      \n\
      /* we have to handle memory as a special case. */\n\
      if ( strncmp(option, MEM_MEG_PREFIX, 2 ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(MEM_MEG_PREFIX) ) /* We cannot have a space before the number */\n\
	    {\n\
	      sscanf( options->nextvalue(), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
		{\n\
		  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
		  options->next();\n\
		}\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized memory size.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
          else\n\
	    {\n\
              sscanf( options->value() + strlen(MEM_MEG_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized memory size.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  mem.set(temp * 0x100000L); /* times 1 Meg. */\n\
          continue;\n\
        };\n\
      if ( strncmp(option, MEM_K_PREFIX, strlen(MEM_K_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(MEM_K_PREFIX) ) /* We cannot have a space before the number */\n\
	    {\n\
	      sscanf( options->nextvalue(), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
		{\n\
		  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
		  options->next();\n\
		}\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized memory size.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
          else\n\
	    {\n\
              sscanf( options->value() + strlen(MEM_K_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized memory size.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  mem.set(temp * 0x400L); /* times 1 Kilobyte. */\n\
          continue;\n\
        };\n\
\n\
#ifdef HASHC\n\
      // added by Uli\n\
      if ( strncmp(option, NUM_BITS_PREFIX, strlen(NUM_BITS_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(NUM_BITS_PREFIX) )\n\
          // there is a space before the number\n\
            {\n\
              sscanf( options->nextvalue(), \"%s\", temp_str );\n\
              if (isdigit(temp_str[0]))\n\
                {\n\
                  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
                  options->next();\n\
                }\n\
              else\n\
                Error.Notrace(\"Unrecognized number of bits.\",\n\
                              argv[0]);\n\
            }\n\
          else   // no space\n\
            {\n\
              sscanf( options->value() + strlen(NUM_BITS_PREFIX), \"%s\", temp_str );\n\
              if (isdigit(temp_str[0]))\n\
                sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
              else\n\
                Error.Notrace(\"Unrecognized number of bits.\",\n\
                              argv[0]);\n\
            }\n\
          if (temp>64 || temp<1)\n\
            Error.Notrace(\"Number of bits not allowed.\");\n\
          num_bits.set(temp);\n\
          continue;\n\
        };\n\
\n\
      // added by Uli\n\
      if ( strncmp(option, TRACE_DIR_PREFIX, strlen(TRACE_DIR_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(TRACE_DIR_PREFIX) )\n\
          // there is a space before the filename\n\
            {\n\
              sscanf( options->nextvalue(), \"%s\", temp_str );\n\
              options->next();\n\
            }\n\
          else   // no space\n\
            {\n\
              sscanf( options->value() + strlen(NUM_BITS_PREFIX), \"%s\", temp_str\n\
);\n\
            }\n\
          TraceFile = new TraceFileManager(temp_str);\n\
          trace_file.set(TRUE);\n\
          continue;\n\
        };\n\
#endif\n\
\n\
      if ( strncmp(option, LOOPMAX_PREFIX, strlen(LOOPMAX_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(LOOPMAX_PREFIX) ) /* We cannot have a space before the number */\n\
	    {\n\
	      sscanf( options->nextvalue(), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
		{\n\
		  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
		  options->next();\n\
		}\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized iterations number.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
          else\n\
	    {\n\
              sscanf( options->value() + strlen(LOOPMAX_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized iterator number.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  loopmax.set(temp);\n\
          continue;\n\
        };\n\
      if ( strncmp(option, PERM_LIMIT, strlen(PERM_LIMIT) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(PERM_LIMIT) ) /* We cannot have a space before the number */\n\
	    {\n\
	      sscanf( options->nextvalue(), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
		{\n\
		  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
		  options->next();\n\
		}\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized permutation limit number.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
          else\n\
	    {\n\
              sscanf( options->value() + strlen(PERM_LIMIT), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized permutation limit number.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  perm_limit.set(temp);\n\
          continue;\n\
        };\n\
      if ( strncmp(option, TEST1_PREFIX, strlen(TEST1_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(TEST1_PREFIX) ) /* We cannot have a space before the number */\n\
	    Error.Notrace(\"Unrecognized test parameter 1.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
          else\n\
	    {\n\
	      sscanf( options->value() + strlen(TEST1_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized test parameter 1.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  test_parameter1.set(temp);\n\
          continue;\n\
        };\n\
      if ( strncmp(option, TEST2_PREFIX, strlen(TEST2_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(TEST2_PREFIX) ) /* We cannot have a space before the number */\n\
	    Error.Notrace(\"Unrecognized test parameter 2.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
          else\n\
	    {\n\
	      sscanf( options->value() + strlen(TEST2_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized test parameter 2.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  test_parameter2.set(temp);\n\
          continue;\n\
        };\n\
      if( strcmp( option, SIMULATE_FLAG ) == 0 )\n\
        {\n\
          main_alg.set(argmain_alg::Simulate);\n\
          continue;\n\
        }\n\
      if( strcmp( option, VERIFY_FLAG ) == 0 )\n\
        {\n\
          main_alg.set(argmain_alg::Verify_bfs);\n\
          continue;\n\
        }\n\
      if( strcmp( option, VERIFY_BFS_FLAG ) == 0 )\n\
        {\n\
          main_alg.set(argmain_alg::Verify_bfs);\n\
          continue;\n\
        }\n\
      if( strcmp( option, VERIFY_DFS_FLAG ) == 0 )\n\
        {\n\
          main_alg.set(argmain_alg::Verify_dfs);\n\
          continue;\n\
        }\n\
      if( strcmp( option, NO_DEADLOCK_FLAG ) == 0 )\n\
        {\n\
          no_deadlock.set(TRUE);\n\
          continue;\n\
        }\n\
      if( strcmp( option, CONTINUE_AFTER_ERROR_FLAG ) == 0 )\n\
        {\n\
          find_errors.set(TRUE);\n\
          continue;\n\
        }\n\
      if( strncmp( option, MAX_NUM_ERRORS_PREFIX, strlen(MAX_NUM_ERRORS_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(MAX_NUM_ERRORS_PREFIX) )\n\
	    {\n\
	      sscanf( options->nextvalue(), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
		{\n\
		  sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
		  options->next();\n\
		}\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized maximum number of errors.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
          else\n\
	    {\n\
              sscanf( options->value() + strlen(MAX_NUM_ERRORS_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized maximum number of errors.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
	  max_errors.set(temp); /* times 1 Meg. */\n\
          continue;\n\
        };\n\
      /* control frequency of printouts. */\n\
      if ( strcmp( option, VERBOSE_FLAG ) == 0 )\n\
        {\n\
          verbose.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_10_FLAG ) == 0 )\n\
        {\n\
          progress_count.set(10);\n\
          print_progress.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_100_FLAG ) == 0 )\n\
        {\n\
          progress_count.set(100);\n\
          print_progress.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_1000_FLAG ) == 0 )\n\
        {\n\
          progress_count.set(1000);\n\
          print_progress.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_10000_FLAG ) == 0 )\n\
        {\n\
          progress_count.set(10000);\n\
          print_progress.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_100000_FLAG ) == 0 )\n\
        {\n\
          progress_count.set(100000);\n\
          print_progress.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, PRINT_NONE_FLAG ) == 0 )\n\
        {\n\
          print_progress.set(FALSE);\n\
          continue;\n\
        }\n\
      /* handle trace types. */\n\
      if ( strcmp( option, TRACE_VIOLATE_FLAG ) == 0 )\n\
        {\n\
          print_trace.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, TRACE_DIFF_FLAG ) == 0 )\n\
        {\n\
          print_trace.set(TRUE);\n\
          full_trace.set(FALSE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, TRACE_FULL_FLAG ) == 0 )\n\
        {\n\
          print_trace.set(TRUE);\n\
          full_trace.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, TRACE_ALL_FLAG ) == 0 )\n\
       {\n\
          print_trace.set(TRUE);\n\
          trace_all.set(TRUE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, TRACE_NONE_FLAG ) == 0 )\n\
        {\n\
          print_trace.set(FALSE);\n\
          continue;\n\
        }\n\
      if ( strcmp( option, HELP_FLAG ) == 0 )\n\
        {\n\
          print_options.set(TRUE);\n\
          no_verification = TRUE;\n\
          continue;\n\
        }\n\
      if ( strcmp( option, LICENSE_FLAG ) == 0 )\n\
        {\n\
          print_license.set(TRUE);\n\
          continue;\n\
        }\n\
      if( strcmp( option, PRINT_RULE_FLAG ) == 0 )\n\
        {\n\
	  print_rule.set(TRUE);\n\
          continue;\n\
        }\n\
//       if( strcmp( option, PRINT_HASH_FLAG ) == 0 )\n\
//         {\n\
// 	  print_hash.set(TRUE);\n\
//           continue;\n\
//         }\n\
//       if( strcmp( option, DEBUG_SYM_FLAG ) == 0 )\n\
//         {\n\
// 	  debug_sym.set(TRUE);\n\
//           continue;\n\
//         }\n\
      if( strcmp( option, NO_SYM_FLAG ) == 0 )\n\
        {\n\
	  symmetry_reduction.set(FALSE);\n\
          continue;\n\
        }\n\
       if( strcmp( option, NO_MULTISET_FLAG ) == 0 )\n\
         {\n\
 	  multiset_reduction.set(FALSE);\n\
           continue;\n\
         }\n\
      if ( strncmp(option, SYMMETRY_PREFIX, strlen(SYMMETRY_PREFIX) ) == 0 )\n\
        {\n\
          if ( strlen(option) <= strlen(SYMMETRY_PREFIX) ) /* We cannot have a space before the number */\n\
	    temp = 1;\n\
          else \n\
	    {\n\
	      sscanf( options->value() + strlen(SYMMETRY_PREFIX), \"%s\", temp_str );\n\
	      if (isdigit(temp_str[0]))\n\
	        sscanf( temp_str, \"%u\", (unsigned long) &temp );\n\
	      else	  \n\
		Error.Notrace(\"Unrecognized symmetry algorithm.  Do '%s -h' for list of valid arguments.\",\n\
			      argv[0]);\n\
	    }\n\
\n\
	  symmetry_reduction.set(TRUE);\n\
	  switch (temp) {\n\
 	  case 1:\n\
	    sym_alg.set(argsym_alg::Exhaustive_Fast_Canonicalize);\n\
 	    break;\n\
	  case 2:\n\
	    sym_alg.set(argsym_alg::Heuristic_Fast_Canonicalize);\n\
	    break;\n\
	  case 3:\n\
	    sym_alg.set(argsym_alg::Heuristic_Small_Mem_Canonicalize);\n\
	    break;\n\
 	  case 4:\n\
 	    sym_alg.set(argsym_alg::Heuristic_Fast_Normalize);\n\
 	    break;\n\
	  default:\n\
	    Error.Notrace(\"Unrecognized symmetry algorithm %u.  Do '%s -h' for list of valid arguments.\",\n\
			  temp, argv[0]);\n\
	  }\n\
          continue;\n\
        };\n\
//       if ( StrStr( ALLOWED_FLAGS, option ) == NULL )\n\
        /* strstr isn\\'t in std.h.  Sheesh. And likewise bleah. */\n\
//         {\n\
          Error.Notrace(\"Unrecognized flag %s.  Do '%s -h' for list of valid arguments.\",\n\
                        option, argv[0]);\n\
          continue;\n\
//        }\n\
    }\n\
  if (no_verification) main_alg.set(argmain_alg::Nothing);\n\
}\n\
\n\
void argclass::PrintOptions( void )   // changes by Uli\n\
{\n\
  cout << \"Options:\\n\"\n\
<< \"1) General:\\n\"\n\
<< \"\\t-h            help.\\n\"\n\
<< \"\\t-l            print license.\\n\"\n\
<< \"2) Verification Strategy: (default: -v)\\n\"\n\
<< \"\\t-s            simulate.\\n\"\n\
<< \"\\t-v or -vbfs   verify with breadth-first search.\\n\"\n\
<< \"\\t-vdfs         verify with depth-first search.\\n\"\n\
<< \"\\t-ndl          do not check for deadlock.\\n\"\n\
<< \"3) Others Options: (default: -m8, -p3, -loop1000)\\n\"\n\
<< \"\\t-m<n>         amount of memory for closed hash table in Mb.\\n\"\n\
<< \"\\t-k<n>         same, but in Kb.\\n\"\n\
<< \"\\t-loop<n>      allow loops to be executed at most n times.\\n\"\n\
<< \"\\t-p            make simulation or verification verbose.\\n\"\n\
<< \"\\t-p<n>         report progress every 10^n events, n in 1..5.\\n\"\n\
<< \"\\t-pn           print no progress reports.\\n\"\n\
<< \"\\t-pr           print out rule information.\\n\"\n\
<< \"4) Error Trace Handling: (default: -tn)\\n\"\n\
<< \"\\t-tv           write a violating trace (with default -td).\\n\"\n\
<< \"\\t-td           write only state differences from the previous states.\\n\"\n\
<< \"\\t              (in simulation mode, write only state differences in\\n\"\n\
<< \"\\t               verbose mode.)\\n\"\n\
<< \"\\t-tf           write full states in trace.\\n\"\n\
<< \"\\t              (in simulation mode, write full states in verbose mode.)\\n\"\n\
<< \"\\t-ta           write all generated states at least once.\\n\"\n\
<< \"\\t-tn           write no trace (default).\\n\"\n\
<< \"5) Reduction Technique: (default: -sym3 with -permlimit 10 and multiset\\n\"\n\
<< \"                                  reduction)\\n\"\n\
<< \"\\t-nosym        no symmetry reduction (multiset reduction still effective)\\n\"\n\
<< \"\\t-nomultiset   no multiset reduction\\n\"\n\
<< \"\\t-sym<n>       reduction by symmetry\\n\"\n\
<< \"\\t-permlimit<n> max num of permutation checked in alg 3\\n\"\n\
<< \"\\t              (for canonicalization, set it to zero)\"\n\
<< \"\\n\"\n\
<< \"\\t              n | methods\\n\"\n\
<< \"\\t              -----------------------------------\\n\"\n\
<< \"\\t              1 | exhaustive canonicalize\\n\"\n\
<< \"\\t              2 | heuristic fast canonicalization\\n\"\n\
<< \"\\t                  (can be slower or faster than alg 3 canonicalization)\\n\"\n\
<< \"\\t                  (use a lot of auxiliary memory for large scalarsets)\\n\"\n\
<< \"\\t              3 | heuristic small mem canonicaliztion/normalization\\n\"\n\
<< \"\\t                  (depends on -permlimit)\\n\"\n\
<< \"\\t              4 | heuristic fast normalization (alg 3 with -permlimit 1)\\n\"\n\
#ifdef HASHC\n\
<< \"6) Hash Compaction: (default: hash compaction with \" << DEFAULT_BITS\n\
  << \" bits)\\n\"\n\
<< \"\\t-b<n>         number of bits to store.\\n\"\n\
<< \"\\t-d dir        write trace info into file dir/\" \n\
  << PROTOCOL_NAME << TRACE_FILE << \".\\n\"\n\
#endif\n\
<< \"\\n\";\n\
//  cout.flush();\n\
/*\n\
<< \"6) Debug :\"\n\
<< \"\\t-ph           print out hashtable information.\\n\"\n\
<< \"\\t-debugsym     run two hashtable in parallel.\\n\"\n\
<< \"\\t-test1 <n>    enter test parameter 1.\\n\"\n\
<< \"\\t\\test2 <n>    enter test parameter 2.\\n\"\n\
*/\n\
}\n\
\n\
void argclass::PrintLicense( void )\n\
{\n\
  cout << \"License Notice:\\n\\n\";\n\
  cout << \"\\\n\
Copyright (C) 1992 - 1999 by the Board of Trustees of \\n\\\n\
Leland Stanford Junior University.\\n\\\n\
\\n\\\n\
License to use, copy, modify, sell and/or distribute this software\\n\\\n\
and its documentation any purpose is hereby granted without royalty,\\n\\\n\
subject to the following terms and conditions:\\n\\\n\
\\n\\\n\
1.  The above copyright notice and this permission notice must\\n\\\n\
appear in all copies of the software and related documentation.\\n\\\n\
\\n\\\n\
2.  The name of Stanford University may not be used in advertising or\\n\\\n\
publicity pertaining to distribution of the software without the\\n\\\n\
specific, prior written permission of Stanford.\\n\\\n\
\\n\\\n\
3.  This software may not be called \\\"Murphi\\\" if it has been modified\\n\\\n\
in any way, without the specific prior written permission of David L.\\n\\\n\
Dill.\\n\\\n\
\\n\\\n\
4.  THE SOFTWARE IS PROVIDED \\\"AS-IS\\\" AND STANFORD MAKES NO\\n\\\n\
REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, BY WAY OF EXAMPLE,\\n\\\n\
BUT NOT LIMITATION.  STANFORD MAKES NO REPRESENTATIONS OR WARRANTIES\\n\\\n\
OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE\\n\\\n\
USE OF THE SOFTWARE WILL NOT INFRINGE ANY PATENTS, COPYRIGHTS\\n\\\n\
TRADEMARKS OR OTHER RIGHTS. STANFORD SHALL NOT BE LIABLE FOR ANY\\n\\\n\
LIABILITY OR DAMAGES WITH RESPECT TO ANY CLAIM BY LICENSEE OR ANY\\n\\\n\
THIRD PARTY ON ACCOUNT OF, OR ARISING FROM THE LICENSE, OR ANY\\n\\\n\
SUBLICENSE OR USE OF THE SOFTWARE OR ANY SERVICE OR SUPPORT.\\n\\\n\
\\n\\\n\
LICENSEE shall indemnify, hold harmless and defend STANFORD and its\\n\\\n\
trustees, officers, employees, students and agents against any and all\\n\\\n\
claims arising out of the exercise of any rights under this Agreement,\\n\\\n\
including, without limiting the generality of the foregoing, against\\n\\\n\
any damages, losses or liabilities whatsoever with respect to death or\\n\\\n\
injury to person or damage to property arising from or out of the\\n\\\n\
possession, use, or operation of Software or Licensed Program(s) by\\n\\\n\
LICENSEE or its customers.\\n\\\n\
\\n\\\n\
Notes:\\n\\\n\
\\n\\\n\
A.  Responsible use:\\n\\\n\
\\n\\\n\
Murphi is to be used as a DEBUGGING AID, not as a means of \\n\\\n\
guaranteeing the correctness of a design.  We do not guarantee\\n\\\n\
that all errors can be caught with Murphi.  There are many\\n\\\n\
reasons for this:\\n\\\n\
\\n\\\n\
1. Specifications and verification conditions do not necessarily\\n\\\n\
capture the conditions necessary for correct operation in practice.\\n\\\n\
\\n\\\n\
2. Many properties cannot be stated Murphi, including timing\\n\\\n\
requirements, performance requirements, \\\"liveness\\\" properties\\n\\\n\
(such as \\\"x will eventually occur\\\") and many others.\\n\\\n\
\\n\\\n\
3. Murphi cannot verify \\\"large\\\" systems.  Almost always, the sizes of\\n\\\n\
various objects in the description must be modelled as being much\\n\\\n\
smaller than they are in reality, in order to make verification\\n\\\n\
feasible.  There is a high probability that design errors will only be\\n\\\n\
manifested when the objects are large.\\n\\\n\
\\n\\\n\
4. The description of a design may not be consistent with what\\n\\\n\
is actually implemented.\\n\\\n\
\\n\\\n\
5.  Murphi may have bugs that cause errors to be overlooked.\\n\\\n\
\\n\\\n\
In short, Murphi is totally inadequate for guaranteeing that there are\\n\\\n\
no errors; however, it is sometimes effective for discovering errors\\n\\\n\
that are difficult to detect by other means.\\n\\\n\
\\n\\\n\
B.  Courtesy\\n\\\n\
\\n\\\n\
Our motivation in distributing this software freely is to encourage\\n\\\n\
others to evaluate its effectiveness on a wider range of applications\\n\\\n\
than we have resources to attempt, and to provide a foundation for\\n\\\n\
further development of automatic verification techniques.\\n\\\n\
\\n\\\n\
We would very much appreciate learning about other's experiences with\\n\\\n\
the system and suggestions for improvements.  Even more, we would\\n\\\n\
appreciate contributions of two kinds: additional verification\\n\\\n\
examples that can be added to the distribution, and enhancements to\\n\\\n\
the verification system.  Although we do not promise to distribute the\\n\\\n\
examples or enhancements, we may do so if feasible.\\n\\\n\
\\n\\\n\
C.  Historical Notes\\n\\\n\
\\n\\\n\
The first version of the Murphi language and verification system was\\n\\\n\
originally designed in 1990-1991 by David Dill, Andreas Drexler, Alan\\n\\\n\
Hu, and C. Han Yang of the Stanford University Computer Systems\\n\\\n\
Laboratory.  The first version of the program was primarily\\n\\\n\
implemented by Andreas Drexler.\\n\\\n\
\\n\\\n\
The Murphi language was extensively modified and extended by David\\n\\\n\
Dill, Alan Hu, Norris Ip, Ralph Melton, Seungjoon Park, and C. Han Yang\\n\\\n\
in 1992.  The new version was almost entirely reimplemented by Ralph\\n\\\n\
Melton during the summer and fall of 1992.\\n\\\n\
\\n\\\n\
Financial and other support for the design and implementation of\\n\\\n\
Murphi has come from many sources, the Defense Advanced Research\\n\\\n\
Projects Agency (under contract number N00039-91-C-0138), the National\\n\\\n\
Science Foundation (grant number MIP-8858807), the Powell Foundation,\\n\\\n\
the Stanford Center for Integrated Systems, the U.S. Office of Naval\\n\\\n\
Research, and Mitsubishi Electronic Laboratories America.  Equipment\\n\\\n\
was provided by Sun Microsystems, the Digital Equipment Corporation,\\n\\\n\
and IBM.\\n\\\n\
\\n\\\n\
These notes are based on information provided to Stanford that has\\n\\\n\
not been independently verified or checked.\\n\\\n\
\\n\\\n\
D.  Support, comments, feedback\\n\\\n\
\\n\\\n\
If you need help or have comments or suggestions regarding Murphi,\\n\\\n\
please send electronic mail to \\\"murphi@verify.stanford.edu\\\".  We do\\n\\\n\
not have the resources to provide commercial-quality support,\\n\\\n\
but we may be able to help you.\\n\\\n\
\\n\\\n\
End of license.\\n\\\n\
\\n\\\n\
===========================================================================\\n\\\n\
\" ;\n\
  \n\
}\n\
\n\
/************************************************************/\n\
/* ReportManager */\n\
/************************************************************/\n\
\n\
ReportManager::ReportManager()\n\
{\n\
  cout.setf(ios::fixed, ios::floatfield);\n\
  cout.precision(2);\n\
}\n\
\n\
void ReportManager::print_algorithm()\n\
{\n\
  switch( args->main_alg.mode )\n\
    {\n\
    case argmain_alg::Verify_bfs:\n\
      cout << \"\\nAlgorithm:\\n\";\n\
      cout << \"\\tVerification by breadth first search.\\n\";\n\
#ifdef HASHC\n\
//      cout << \"\\tWarning: the trace cannot be printed when using\\n\"\n\
//	   << \"\\thash compression and breadth first search.\\n\";\n\
#endif\n\
      break;\n\
    case argmain_alg::Verify_dfs:\n\
      cout << \"\\nAlgorithm:\\n\";\n\
      cout << \"\\tVerification by depth first search.\\n\";\n\
      break;\n\
    case argmain_alg::Simulate:\n\
      cout << \"\\nAlgorithm:\\n\";\n\
      cout << \"\\tSimulation.\\n\";\n\
      break;\n\
    default:\n\
      break;\n\
    }\n\
\n\
  if (  args->symmetry_reduction.value\n\
     && (  args->main_alg.mode == argmain_alg::Verify_dfs \n\
	|| args->main_alg.mode == argmain_alg::Verify_bfs) )\n\
    {\n\
      cout << \"\\twith symmetry algorithm \";\n\
      switch(args->sym_alg.mode) {\n\
      case argsym_alg::Exhaustive_Fast_Canonicalize:\n\
	cout << \"1 -- Exhaustive Fast Canonicalization.\\n\"; break;\n\
      case argsym_alg::Heuristic_Fast_Canonicalize:\n\
	cout << \"2 -- Heuristic Fast Canonicalization.\\n\"; break;\n\
      case argsym_alg::Heuristic_Small_Mem_Canonicalize:\n\
	if (args->perm_limit.value ==0)\n\
	  { cout << \"3 -- Heuristic Small Memory Canonicalization.\\n\"; break; }\n\
	else\n\
	  { cout << \"3 -- Heuristic Small Memory Normalization\\n\"\n\
		 << \"\\twith permutation trial limit \"\n\
		 << args->perm_limit.value << \".\\n\"; break; }\n\
      case argsym_alg::Heuristic_Fast_Normalize:\n\
	cout << \"4 -- Heuristic Small Memory/Fast Normalization.\\n\"; break;\n\
      default:\n\
	cout << \"??.\\n\"; break;\n\
      }\n\
    }\n\
}\n\
\n\
// added by Uli\n\
void ReportManager::print_warning()\n\
{\n\
  if ((args->main_alg.mode==argmain_alg::Verify_bfs ||\n\
       args->main_alg.mode==argmain_alg::Verify_dfs) && \n\
      !args->print_trace.value)\n\
    cout << \"\\nWarning: No trace will not be printed \"\n\
         << \"in the case of protocol errors!\\n\" \n\
         << \"         Check the options if you want to have error traces.\\n\";\n\
}\n\
 \n\
void ReportManager::CheckConsistentVersion()\n\
{\n\
  if (strcmp(MURPHI_VERSION, INCLUDE_FILE_VERSION) !=0 )\n\
    { \n\
      cout << \"\\nWarning:\\n\\n\\t\";\n\
      cout << \"Different versions of include files and mu are used\\n\";\n\
    }\n\
}  \n\
\n\
void ReportManager::StartSimulation()\n\
{\n\
  cout << \"Start Simulation :\\n\\n\";\n\
}\n\
\n\
/****************************************\n\
  Printing functions.\n\
\n\
  Coordinated by class ReportManager\n\
  ****************************************/\n\
\n\
/************************************************************/\n\
void ReportManager::print_header( void )   // changes by Uli\n\
{\n\
  cout << \"\\n=====================================\"\n\
       << \"=====================================\\n\"\n\
       << MURPHI_VERSION << \"\\n\"\n\
       << \"Finite-state Concurrent System Verifier.\\n\"\n\
       << \"\\n\"\n\
       << \"Copyright (C) 1992 - 1999 by the Board of Trustees of\\n\"\n\
       << \"Leland Stanford Junior University.\\n\"\n\
       << \"\\n=====================================\"\n\
       << \"=====================================\\n\"\n\
       << \"\\nProtocol: \" << PROTOCOL_NAME << \"\\n\";\n\
\n\
  // cout.flush(); // flushing cout had seemed to cause some weirdnesses.\n\
}\n\
\n\
\n\
// since we may use symmetry, which permute entries in the state,\n\
// the pointer in the state set doesn`t exactly point to its\n\
// parent, but to a permutation of its parent.\n\
//\n\
// therefore we have to regenerate the trace from the rules used to\n\
// generate the states\n\
\n\
/************************************************************/\n\
/* Norris: to be moved to state set */\n\
void ReportManager::print_trace_with_theworld()   // changes by Uli\n\
{\n\
#ifdef HASHC\n\
  if ( args->main_alg.mode == argmain_alg::Verify_bfs &&\n\
       !args->trace_file.value )\n\
      return;\n\
  if (args->trace_file.value)\n\
    StateSet->print_trace_aux(NumCurState);\n\
  else\n\
#endif\n\
    StateSet->print_trace_aux(curstate);\n\
\n\
  // execute the last rule to call \n\
  // Error_handler::Error(...) again, so that\n\
  // variable \"theworld\" will have the fragment of the last state.\n\
  //StateCopy(workingstate, curstate);\n\
  (void) Rules->AllNextStates();\n\
  Error.Notrace(\"Internal: The error assertion associated with the last state disappeared.\");\n\
}\n\
\n\
/************************************************************/\n\
/* Norris: to be moved to state set */\n\
void ReportManager::print_trace_with_curstate()   // changes by Uli\n\
{\n\
#ifdef HASHC\n\
  if ( args->main_alg.mode == argmain_alg::Verify_bfs &&\n\
       !args->trace_file.value )\n\
      return;\n\
  if (args->trace_file.value)   \n\
    StateSet->print_trace(NumCurState);\n\
  else\n\
#endif\n\
    StateSet->print_trace(curstate);\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_progress( void )\n\
{\n\
  static bool initialized = FALSE;\n\
  \n\
  // pring progress report every <args->progress_count> new states found\n\
  if (  args->print_progress.value \n\
	&& StateSet->NumElts() % args->progress_count.value == 0 )\n\
    {\n\
      if (!initialized) \n\
	{  \n\
	  cout << \"\\nProgress Report:\\n\\n\";\n\
	  initialized = TRUE;\n\
	} \n\
      cout << \"\\t\" \n\
	   << StateSet->NumElts() << \" states explored in \"\n\
	   << SecondsSinceStart() << \"s, with \"\n\
	   << Rules->NumRulesFired() << \" rules fired and \"\n\
	   << StateSet->QueueNumElts() << \" states in the queue.\\n\";\n\
      cout.flush();\n\
    }\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_no_error( void )\n\
{\n\
  cout << \"\\n=====================================\"\n\
       << \"=====================================\\n\"\n\
       << \"\\nStatus:\\n\" \n\
       << \"\\n\\tNo error found.\\n\";\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_summary(bool prob)\n\
{\n\
  bool exist = FALSE;\n\
  \n\
  cout << \"\\nState Space Explored:\\n\\n\"\n\
       << \"\\t\"\n\
       << StateSet->NumElts() << \" states, \"\n\
       // Uli: do not print 'reduced states' in official release\n\
       // << StateSet->NumEltsReduced() << \" reduced states, \"\n\
       << Rules->NumRulesFired() << \" rules fired in \"\n\
       << SecondsSinceStart() << \"s.\\n\\n\";\n\
\n\
  if (prob) {\n\
#ifdef HASHC\n\
    // Uli: print omission probabilities\n\
    StateSet->PrintProb();\n\
#endif\n\
  }\n\
 \n\
  Rules->print_rules_information();\n\
  theworld.print_statistic();\n\
\n\
\n\
}\n\
\n\
// for bfs only -- curstate valid\n\
/************************************************************/\n\
void ReportManager::print_curstate( void )\n\
{\n\
  StateCopy(workingstate, curstate);\n\
  cout << \"------------------------------\\n\"\n\
       << \"Unpacking state from queue:\\n\";\n\
  theworld.print();\n\
  cout << \"\\nThe following next states are obtained:\\n\"\n\
       << '\\n';\n\
}\n\
\n\
// for dfs only\n\
/************************************************************/\n\
void ReportManager::print_dfs_deadlock( void )\n\
{\n\
  cout << \"------------------------------\\n\"\n\
       << \"No more rule can be fired.\\n\"\n\
       << \"------------------------------\\n\";\n\
}\n\
\n\
// for dfs only\n\
/************************************************************/\n\
void ReportManager::print_retrack( void )\n\
{\n\
  if (!StateSet->QueueIsEmpty())\n\
    {\n\
      curstate = StateSet->QueueTop();\n\
      StateCopy(workingstate, curstate);\n\
      cout << \"------------------------------\\n\";\n\
      cout << \"No more rule can be fired. Backup one state from the stack:\\n\";\n\
      theworld.print();\n\
      cout << '\\n';\n\
    }\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_fire_startstate()\n\
{\n\
  cout << \"Firing startstate \" \n\
       << StartState->LastStateName() \n\
       << \"\\n\"\n\
       << \"Obtained state:\\n\";\n\
  theworld.print();\n\
  cout << '\\n';\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_fire_rule()\n\
{\n\
  cout << \"Firing rule \"\n\
       << Rules->LastRuleName()\n\
       << '\\n'\n\
       << \"Obtained state:\\n\";\n\
  theworld.print();\n\
  cout << '\\n';\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_fire_rule_diff(state * s)\n\
{\n\
  cout << \"Firing rule \"\n\
       << Rules->LastRuleName()\n\
       << '\\n'\n\
       << \"Obtained state:\\n\";\n\
  theworld.print_diff(s);\n\
  cout << '\\n';\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_trace_all()\n\
{\n\
  static unsigned long statenum = 1;\n\
  cout << \"State \" << statenum++ << \":\\n\";\n\
  theworld.print();\n\
  cout << '\\n';\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_verbose_header()\n\
{\n\
  cout << \"\\n=====================================\"\n\
       << \"=====================================\\n\"\n\
       << \"Verbose option selected.  The following is the detailed progress.\\n\\n\";\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_hashtable()\n\
{\n\
  StateSet->print_all_states();\n\
}\n\
\n\
/************************************************************/\n\
void ReportManager::print_final_report()\n\
{\n\
  print_no_error();\n\
  print_summary(TRUE);\n\
  if (args->print_hash.value) print_hashtable();\n\
}\n\
\n\
\n\
/****************************************   // added by Uli\n\
  trace info file\n\
  ****************************************/\n\
\n\
#ifdef HASHC\n\
TraceFileManager::TraceFileManager(char* s) \n\
: inBuf(0), last(0)\n\
{\n\
  assert (sizeof(unsigned long)==4);   // the implementation is pretty\n\
                                       // dependent on the 4 bytes\n\
\n\
  // check directory\n\
  if (strlen(s)==0)\n\
    Error.Notrace(\"No directory for trace info file specified.\");\n\
  if (strlen(s)+strlen(PROTOCOL_NAME)+strlen(TRACE_FILE) > 254)\n\
    Error.Notrace(\"Filename for trace info file too long.\");\n\
\n\
  // set filename\n\
  strcpy(name,s);\n\
  if (name[strlen(name)-1] != '/')\n\
    strcat(name,\"/\");\n\
  strcat(name,PROTOCOL_NAME);\n\
  strcat(name,TRACE_FILE);\n\
\n\
  // open file\n\
  if ((fp = fopen(name,\"w+b\")) == NULL)\n\
    Error.Notrace(\"Problems opening trace info file %s.\", name);\n\
}\n\
\n\
TraceFileManager::~TraceFileManager()\n\
{\n\
  // delete file\n\
  remove(name);\n\
}\n\
\n\
void TraceFileManager::setBytes(int bits)\n\
{\n\
  numBytes = (bits-1)/8 + 1;\n\
}\n\
\n\
unsigned long TraceFileManager::numLast()\n\
{\n\
  return last;\n\
}\n\
\n\
// routines for reading and writing\n\
// remarks:\n\
// - format: 4 bytes   for the number of the previous state\n\
//           numBytes  for the compressed value\n\
// - states are numbered beginning with 1\n\
\n\
void TraceFileManager::writeLong(unsigned long l, int bytes)\n\
{\n\
  for (int i=0; i<bytes; i++)\n\
    if (fputc(int(l>>(3-i)*8 & 0xffUL), fp) == EOF)\n\
      Error.Notrace(\"Problems writing to trace info file %s.\", name);\n\
}\n\
  \n\
void TraceFileManager::write(unsigned long c1, unsigned long c2, \n\
                        unsigned long previous)\n\
{\n\
  writeLong(previous, 4);\n\
  writeLong(c1, numBytes>4 ? 4 : numBytes);\n\
  if (numBytes>4)\n\
    writeLong(c2, numBytes-4);\n\
  last++;\n\
}\n\
\n\
unsigned long TraceFileManager::readLong(int bytes)\n\
{\n\
  unsigned long ret=0;\n\
  int g;\n\
\n\
  for (int i=0; i<bytes; i++)\n\
    if ((g=fgetc(fp)) == EOF)\n\
      Error.Notrace(\"Problems reading from trace info file %s.\", name);\n\
    else\n\
      ret |= ((unsigned long)g & 0xffUL) << (3-i)*8;\n\
\n\
  return ret;\n\
}\n\
\n\
const TraceFileManager::Buffer* TraceFileManager::read(unsigned long number)\n\
{\n\
  if (number!=inBuf) \n\
  {\n\
    if (fseek(fp, (number-1)*(4+numBytes), SEEK_SET))\n\
      Error.Notrace(\"Problems during seek in trace info file %s.\", name);\n\
\n\
    buf.previous = readLong(4);\n\
    buf.c1 = readLong(numBytes>4 ? 4 : numBytes);\n\
    if (numBytes>4) \n\
      buf.c2 = readLong(numBytes-4);\n\
\n\
    inBuf = number;\n\
  }\n\
\n\
  return &buf;\n\
}\n\
#endif\n\
\n\
\n\
/****************************************\n\
  * 1 Dec 93 Norris Ip: \n\
  add -sym option to select symmetry reduction \n\
  * 8 Feb 94 Norris Ip:\n\
  add print hashtable for debugging\n\
  * 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
  * 6 April 94 Norris Ip:\n\
  fixed error trace \n\
  * 12 April 94 Norris Ip:\n\
  add information about error in the condition of the rules\n\
  category = CONDITION\n\
  * 14 April 94 Norris Ip:\n\
  change numbering of symmetry algorithms\n\
  * 14 April 94 Norris Ip:\n\
  change io so that numbers are checked to be really number\n\
  * 14 April 94 Norris Ip:\n\
  change io so that sym is default\n\
  added -nosym flag\n\
  * 18 April 94 Norris Ip:\n\
  error trace printing fixed (internal error when invariant failed)\n\
  * 20 Oct 94\n\
  Tidy up and Objectized the code\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_io.C,v $\n\
  Revision 1.3  1999/01/29 08:28:09  uli\n\
  efficiency improvements for security protocols\n\
\n\
  Revision 1.2  1999/01/29 07:49:10  uli\n\
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
