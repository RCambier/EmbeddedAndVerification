namespace murphi { const char *mu_state_h_str = "\
/* -*- C++ -*- \n\
 * mu_state.h\n\
 * @(#) header for routines related to states in the verifier\n\
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
#ifndef _STATE_\n\
#define _STATE_\n\
\n\
/****************************************\n\
  There are three different declarations:\n\
  1) state\n\
  2) dynBitVec\n\
  3) state queue\n\
  4) state set\n\
 ****************************************/\n\
\n\
/****************************************\n\
  The record for a single state.\n\
  require : BITS_IN_WORLD in parameter file\n\
 ****************************************/\n\
\n\
/* BITS_IN_WORLD gets defined by the generated code. */\n\
/* The extra addition is there so that we round up to the greater block. */\n\
\n\
/****************************************\n\
  Bit vector - copied straight from Andreas. \n\
 ****************************************/\n\
class dynBitVec\n\
{\n\
  // data\n\
  unsigned long numBits;\n\
  unsigned char* v;\n\
  \n\
  // Inquiries\n\
  inline unsigned int Index( unsigned long index ) { return index / 8; }\n\
  inline unsigned int Shift( unsigned long index ) { return index % 8; }\n\
  \n\
public:\n\
  // initializer\n\
  dynBitVec( unsigned long nBits );\n\
  // destructor\n\
  virtual ~dynBitVec();\n\
  \n\
  // interface\n\
  inline int NumBits( void ) { return numBits; }\n\
  inline int NumBytes( void ) { return 1 + (numBits - 1) / 8; }\n\
  inline void clear( unsigned long i ) { v[ Index(i) ] &= ~(1 << Shift(i)); }\n\
  inline void set( unsigned long i ) { v[ Index(i) ] |=  (1 << Shift(i)); }\n\
  inline int get( unsigned long i ) { return (v[ Index(i) ] >> Shift(i)) & 1; }\n\
};\n\
\n\
class statelist\n\
{\n\
  state * s;\n\
  statelist * next;\n\
public:\n\
  statelist(state * s, statelist * next) \n\
  : s(s), next(next) {};\n\
};\n\
\n\
/****************************************\n\
  The state queue.\n\
 ****************************************/\n\
class state_queue\n\
{\n\
protected:\n\
  state** stateArray;                     /* The actual array. */\n\
  const unsigned long max_active_states;  /* max size of queue */\n\
  unsigned long front;                    /* index of first active state. */\n\
  unsigned long rear;                     /* index of next free slot. */\n\
  unsigned long num_elts;                  /* number of elements. */\n\
  \n\
public:\n\
  // initializers\n\
  state_queue( unsigned long mas );\n\
\n\
  // destructor\n\
  virtual ~state_queue();\n\
  \n\
  // information interface\n\
  inline unsigned long MaxElts( void ) { return max_active_states; }\n\
  unsigned long NumElts( void ) { return num_elts; }\n\
  inline static int BytesForOneState( void ); \n\
  inline bool isempty( void ) { return num_elts == 0; }\n\
  \n\
  // storing and removing elements\n\
  virtual void enqueue( state* e );\n\
  virtual state* dequeue( void );\n\
  virtual state * top( void );\n\
  \n\
  virtual unsigned NextRuleToTry()   // Uli: unsigned short -> unsigned\n\
  {\n\
    Error.Notrace(\"Internal: Getting next rule to try from a state queue instead of a state stack.\");\n\
    return 0;\n\
  }\n\
  virtual void NextRuleToTry(unsigned r)\n\
  {\n\
    Error.Notrace(\"Internal: Setting next rule to try from a state queue instead of a state stack.\");\n\
  }\n\
\n\
  // printing routine\n\
  void Print( void );\n\
  virtual void print_capacity( void )\n\
  {\n\
    cout << \"\\t* Capacity in queue for breadth-first search: \"\n\
	 << max_active_states << \" states.\\n\"\n\
	 << \"\\t   * Change the constant gPercentActiveStates in mu_prolog.inc\\n\"\n\
         << \"\\t     to increase this, if necessary.\\n\"; \n\
  }\n\
};\n\
\n\
class state_stack: public state_queue\n\
{\n\
  unsigned * nextrule_to_try;\n\
\n\
public:\n\
  // initializers\n\
  state_stack( unsigned long mas )\n\
  : state_queue(mas)\n\
  {\n\
    unsigned long i;\n\
    nextrule_to_try = new unsigned [ mas ];\n\
    for ( i = 0; i < mas; i++)\n\
      nextrule_to_try[i] = 0;\n\
  };\n\
\n\
  // destructor\n\
  virtual ~state_stack()\n\
  {\n\
    delete[ OLD_GPP(max_active_states) ] nextrule_to_try; // Should be delete[].\n\
  };\n\
\n\
  virtual void print_capacity( void )\n\
  {\n\
    cout << \"\\t* Capacity in queue for depth-first search: \"\n\
	 << max_active_states << \" states.\\n\" \n\
         << \"\\t   * Change the constant gPercentActiveStates in mu_prolog.inc\\n\"\n\
         << \"\\t     to increase this, if necessary.\\n\";   \n\
  }\n\
  virtual void enqueue( state* e );\n\
\n\
  virtual unsigned NextRuleToTry()\n\
  {\n\
    return nextrule_to_try[ front ];\n\
  }\n\
  virtual void NextRuleToTry(unsigned r)\n\
  {\n\
    nextrule_to_try[ front ] = r;\n\
  }\n\
  \n\
#ifdef partial_order_opt\n\
  // special interface with sleepset\n\
  virtual void enqueue( state *e, sleepset s );\n\
#endif\n\
};\n\
\n\
/****************************************\n\
  The state set\n\
  represented as a large open-addressed hash table.\n\
 ****************************************/\n\
\n\
class state_set\n\
{\n\
#ifdef HASHC\n\
  typedef unsigned long Unsigned32;    // basic building block of the hash \n\
                                       // table, slots may have different size\n\
#endif\n\
\n\
  // data\n\
  unsigned long table_size;            /* max size of the hash table */\n\
#ifndef HASHC\n\
  state *table;                        /* pointer to the hash table */\n\
#else\n\
  Unsigned32 *table;\n\
#endif\n\
  dynBitVec *Full;                     /* whether element table[i] is used. */\n\
  unsigned long num_elts;              /* number of elements in table */\n\
  unsigned long num_elts_reduced;   // Uli\n\
  unsigned long num_collisions;        /* number of collisions in hashing */ \n\
\n\
  // internal routines\n\
  bool is_empty( unsigned long i )     /* check if element table[i] is empty */\n\
  { return Full->get(i) == 0; };\n\
\n\
public:\n\
  // constructors\n\
  state_set ( unsigned long table_size );\n\
  state_set ( void );\n\
\n\
  friend void copy_state_set( state_set * set1, state_set * set2);\n\
\n\
  void clear_state_set();\n\
\n\
  // destructor\n\
  virtual ~state_set();\n\
\n\
  // checking the presence of state \"in\"\n\
  bool simple_was_present( state *&in, bool, bool );  \n\
    /* old was_present without checking -sym */\n\
  bool was_present( state *&in, bool, bool );\n\
    /* checking -sym before calling simple_was_present() */\n\
  \n\
  // get the size of each state entry\n\
#ifndef VER_PSEUDO\n\
  static int bits_per_state(void);\n\
#endif\n\
  \n\
  // get the number of elts in the state set\n\
  inline unsigned long NumElts() { return num_elts; };\n\
\n\
  inline unsigned long NumEltsReduced() { return num_elts_reduced; };   // Uli\n\
  \n\
  // printing information\n\
  void print_capacity( void );\n\
\n\
  // print hashtable       \n\
  void print()\n\
  {\n\
    for (unsigned long i=0; i<table_size; i++)\n\
      if (!is_empty(i))\n\
	{\n\
	  cout << \"State \" << i << \"\\n\";\n\
#ifdef HASHC\n\
	  cout << \"... compressed\\n\";\n\
#else\n\
	  StateCopy(workingstate,&table[i]);\n\
	  theworld.print();\n\
#endif\n\
	  cout << \"\\n\";\n\
	}\n\
  }\n\
};\n\
\n\
/****************************************\n\
  1) 1 Dec 93 Norris Ip: \n\
  check -sym option when checking was_present()\n\
  add Normalize() declaration in class state\n\
  add friend StateCmp to class state\n\
  2) 24 Feb 94 Norris Ip:\n\
  added -debugsym option to run two hash tables in parallel\n\
  for debugging purpose\n\
  3) 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_state.h,v $\n\
  Revision 1.3  1999/01/29 08:28:09  uli\n\
  efficiency improvements for security protocols\n\
\n\
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
\n\
#endif\n\
"; }
