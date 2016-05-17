namespace murphi { const char *mu_io_h_str = "\
/* -*- C++ -*-\n\
 * mu_io.h\n\
 * @(#) header of the interface routines\n\
 *      for the driver for Murphi verifiers.\n\
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
 */\n\
\n\
/****************************************\n\
  There are 3 groups of declarations:\n\
  1) Error_handler\n\
  2) argclass\n\
  3) general printing routine (not belong to any class)\n\
  4) trace info file\n\
 ****************************************/\n\
\n\
/****************************************\n\
  Error handler\n\
 ****************************************/\n\
\n\
class Error_handler\n\
{\n\
  char buffer[BUFFER_SIZE];	// for vsprintf'ing error messages prior to cout'ing them.\n\
\n\
  int num_errors;\n\
  int phase;\n\
  int oldphase;\n\
  bool has_error;\n\
  int num_error_curstate;\n\
  int phase_2_done;\n\
\n\
public:\n\
    Error_handler ()\n\
  : num_errors (0), phase (1)\n\
  {\n\
  };\n\
  ~Error_handler () {\n\
  };\n\
\n\
  void StartCountingCurstate ()\n\
  {\n\
    num_error_curstate = 0;\n\
  }\n\
  int ErrorNumCurstate ()\n\
  {\n\
    return num_error_curstate;\n\
  }\n\
  bool Phase2Done ()\n\
  {\n\
    return phase_2_done;\n\
  }\n\
\n\
  void SpecialPhase ()\n\
  {\n\
    oldphase = phase;\n\
    phase = 3;\n\
  };\n\
  void NormalPhase ()\n\
  {\n\
    phase = oldphase;\n\
  };\n\
\n\
  void ResetErrorFlag ()\n\
  {\n\
    phase = 3;\n\
    has_error = FALSE;\n\
  }\n\
  bool NoError ()\n\
  {\n\
    return !has_error;\n\
  };\n\
\n\
  int NumError ()\n\
  {\n\
    return num_errors;\n\
  };\n\
\n\
  void Error (const char *fmt, ...);	/* called like printf. */\n\
  void Deadlocked (const char *fmt, ...);	/* When we\\'re not in a rule.\n\
						   currently only in deadlock */\n\
  void Notrace (const char *fmt, ...);	/* Doesn\\'t print a trace. */\n\
};\n\
\n\
/****************************************\n\
  iterator for argument class\n\
 ****************************************/\n\
\n\
/* abstract class for mapping over a list of strings. */\n\
class string_iterator\n\
{\n\
  /* restrictions:\n\
   * Also, you can\\'t have more than one of these going at a time. */\n\
public:\n\
  virtual char *value () = 0;\n\
  virtual char *nextvalue () = 0;\n\
  virtual string_iterator & next () = 0;\n\
  virtual bool done () = 0;\n\
  virtual void start () = 0;\n\
};\n\
\n\
class arg_iterator:public string_iterator\n\
{\n\
  int argc;\n\
  char **argv;\n\
  int index;\n\
public:\n\
    arg_iterator (int argc, char **argv)\n\
  : argc (argc), argv (argv), index (1)\n\
  {\n\
  };				/* index(1) to skip the program name. */\n\
  virtual char *value ()\n\
  {\n\
    return argv[index];\n\
  };\n\
  virtual char *nextvalue ()\n\
  {\n\
    if (index + 1 >= argc)\n\
      return \"\";\n\
    else\n\
      return argv[index + 1];\n\
  };\n\
  virtual string_iterator & next ()\n\
  {\n\
    index++;\n\
    return *this;\n\
  }\n\
  virtual bool done ()\n\
  {\n\
    return (index >= argc);\n\
  }\n\
  virtual void start ()\n\
  {\n\
  };\n\
};\n\
\n\
class strtok_iterator:public string_iterator\n\
/* uses strtok() to break up into strings. */\n\
{\n\
  char *old;\n\
  char *current;\n\
public:\n\
    strtok_iterator (char *s)\n\
  : old (s), current (NULL)\n\
  {\n\
    start ();\n\
  };\n\
  virtual char *value ()\n\
  {\n\
    return current;\n\
  };\n\
  virtual string_iterator & next ()\n\
  {\n\
    current = strtok (NULL, \" \");\n\
    return *this;\n\
  }\n\
  virtual bool done ()\n\
  {\n\
    return (current == NULL);\n\
  }\n\
  virtual void start ()\n\
  {\n\
    if (old != NULL)\n\
      current = strtok (tsprintf (\"%s\", old), \" \");\n\
  };\n\
  /* we can\\'t count on strdup() being there, unfortunately. */\n\
};\n\
\n\
/****************************************\n\
  argument class\n\
 ****************************************/\n\
class argmain_alg\n\
{\n\
public:\n\
  enum MainAlgorithmtype\n\
  { Nothing, Simulate, Verify_bfs, Verify_dfs };\n\
  MainAlgorithmtype mode;	/* What to do. */\n\
private:\n\
    bool initialized;\n\
  char *name;\n\
public:\n\
    argmain_alg (MainAlgorithmtype t, char *n):mode (t), initialized (FALSE),\n\
    name (n)\n\
  {\n\
  };\n\
  ~argmain_alg () {\n\
  };\n\
  void set (MainAlgorithmtype t)\n\
  {\n\
    if (!initialized) {\n\
      initialized = TRUE;\n\
      mode = t;\n\
    }\n\
    else if (mode != t)\n\
      Error.Notrace (\"Conflicting options to %s.\", name);\n\
  };\n\
};\n\
\n\
class argsym_alg\n\
{\n\
public:\n\
  enum SymAlgorithmType\n\
  { Exhaustive_Fast_Canonicalize,\n\
    Heuristic_Fast_Canonicalize,\n\
    Heuristic_Small_Mem_Canonicalize,\n\
    Heuristic_Fast_Normalize\n\
  };\n\
  SymAlgorithmType mode;	/* What to do. */\n\
private:\n\
    bool initialized;\n\
  char *name;\n\
public:\n\
    argsym_alg (SymAlgorithmType t, char *n):mode (t), initialized (FALSE),\n\
    name (n)\n\
  {\n\
  };\n\
  ~argsym_alg () {\n\
  };\n\
  void set (SymAlgorithmType t)\n\
  {\n\
    if (!initialized) {\n\
      initialized = TRUE;\n\
      mode = t;\n\
    }\n\
    else if (mode != t)\n\
      Error.Notrace (\"Conflicting options to %s.\", name);\n\
  };\n\
};\n\
\n\
class argnum\n\
{\n\
public:\n\
  unsigned long value;\n\
private:\n\
    bool initialized;\n\
  char *name;\n\
public:\n\
    argnum (unsigned long val, char *n):value (val), initialized (FALSE),\n\
    name (n)\n\
  {\n\
  };\n\
  ~argnum () {\n\
  };\n\
  void set (unsigned long val)\n\
  {\n\
    if (!initialized) {\n\
      initialized = TRUE;\n\
      value = val;\n\
    }\n\
    else if (val != value)\n\
      Error.Notrace (\"Conflicting options to %s.\", name);\n\
  };\n\
};\n\
\n\
class argbool\n\
{\n\
public:\n\
  bool value;\n\
private:\n\
  bool initialized;\n\
  char *name;\n\
public:\n\
    argbool (bool val, char *n):value (val), initialized (FALSE), name (n)\n\
  {\n\
  };\n\
  ~argbool () {\n\
  };\n\
  void reset (bool val)\n\
  {\n\
    initialized = TRUE;\n\
    value = val;\n\
  }\n\
  void set (bool val)\n\
  {\n\
    if (!initialized) {\n\
      initialized = TRUE;\n\
      value = val;\n\
    }\n\
    else if (val != value)\n\
      Error.Notrace (\"Conflicting options to %s.\", name);\n\
  };\n\
};\n\
\n\
/* Argclass inspired by Andreas\\' code. */\n\
class argclass\n\
{\n\
  int argc;\n\
  char **argv;\n\
public:\n\
\n\
  // trace options\n\
    argbool print_trace;\n\
  argbool full_trace;\n\
  argbool trace_all;\n\
  argbool find_errors;\n\
  argnum max_errors;\n\
\n\
  // memory options\n\
  argnum mem;\n\
\n\
  // progress report options\n\
  argnum progress_count;\n\
  argbool print_progress;\n\
\n\
  // main algorithm options\n\
  argmain_alg main_alg;\n\
\n\
  // symmetry option\n\
  argbool symmetry_reduction;\n\
  argbool multiset_reduction;\n\
  argsym_alg sym_alg;\n\
  argnum perm_limit;\n\
  argbool debug_sym;\n\
\n\
  // Uli: hash compaction options\n\
#ifdef HASHC\n\
  argnum num_bits;\n\
  argbool trace_file;\n\
#endif\n\
\n\
  // testing parameter\n\
  argnum test_parameter1;\n\
  argnum test_parameter2;\n\
\n\
  // miscelleneous\n\
  argnum loopmax;\n\
  argbool verbose;\n\
  argbool no_deadlock;\n\
  argbool print_options;\n\
  argbool print_license;\n\
  argbool print_rule;\n\
  argbool print_hash;\n\
\n\
  // supporting routines\n\
    argclass (int ac, char **av);\n\
   ~argclass ()\n\
  {\n\
  };\n\
  void ProcessOptions (string_iterator * options);\n\
  bool Flag (char *arg);\n\
  void PrintInfo (void);\n\
  void PrintOptions (void);\n\
  void PrintLicense (void);\n\
\n\
};\n\
\n\
/****************************************\n\
  Printing functions.\n\
 ****************************************/\n\
\n\
class ReportManager\n\
{\n\
  void print_trace_aux (StatePtr p);	// changed by Uli\n\
public:\n\
    ReportManager ();\n\
  void CheckConsistentVersion ();\n\
  void StartSimulation ();\n\
\n\
  void print_algorithm ();\n\
  void print_warning ();\n\
  void print_header (void);\n\
  void print_trace_with_theworld ();\n\
  void print_trace_with_curstate ();\n\
  void print_progress (void);\n\
  void print_no_error (void);\n\
  void print_summary (bool);	// print omission probabilities only if true\n\
  void print_curstate (void);\n\
  void print_dfs_deadlock (void);\n\
  void print_retrack (void);\n\
  void print_fire_startstate ();\n\
  void print_fire_rule ();\n\
  void print_fire_rule_diff (state * s);\n\
  void print_trace_all ();\n\
  void print_verbose_header ();\n\
  void print_hashtable ();\n\
  void print_final_report ();\n\
};\n\
\n\
/****************************************   // added by Uli\n\
  trace info file.\n\
 ****************************************/\n\
\n\
#ifdef HASHC\n\
class TraceFileManager\n\
{\n\
public:\n\
  struct Buffer\n\
  {				// buffer for read\n\
    unsigned long previous;\n\
    unsigned long c1;\n\
    unsigned long c2;\n\
  };\n\
\n\
private:\n\
  int numBytes;			// number of bytes for compressed values\n\
  char name[256];		// filename for trace info file\n\
  FILE *fp;			// file pointer\n\
  Buffer buf;			// buffer for read\n\
  unsigned long inBuf;		// number of state in buffer (0: empty)\n\
  unsigned long last;		// number of last state written\n\
  void writeLong (unsigned long l, int bytes);\n\
  unsigned long readLong (int bytes);\n\
\n\
public:\n\
    TraceFileManager (char *);\n\
   ~TraceFileManager ();\n\
  void setBytes (int bits);\n\
  unsigned long numLast ();\n\
  void write (unsigned long c1, unsigned long c2, unsigned long previous);\n\
  const Buffer *read (unsigned long number);\n\
};\n\
#endif\n\
\n\
\n\
/****************************************\n\
  1) 1 Dec 93 Norris Ip: \n\
  add symmetry_option field in IO to select symmetry reduction \n\
  add test parameter input for testing\n\
  2) 8 Feb 94 Norris Ip:\n\
  add print hashtable for debugging\n\
  3) 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
  * 14 April 94 Norris Ip:\n\
  add nextvalue() to arg_iterator\n\
  * 19 Oct 94 Norris Ip:\n\
  change to object oriented\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_io.h,v $\n\
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
