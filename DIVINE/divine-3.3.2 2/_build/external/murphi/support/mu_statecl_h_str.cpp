namespace murphi { const char *mu_statecl_h_str = "\
/* -*- C++ -*- \n\
 * mu_statecl.h\n\
 * @(#) header for class state in the verifier\n\
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
 * Created by Denis Leroy\n\
 * Created: Spring 95\n\
 *\n\
 * Update:\n\
 *\n\
 */ \n\
\n\
#ifndef ALIGN\n\
#define BLOCKS_IN_WORLD (((BITS_IN_WORLD + (4*BITS( BIT_BLOCK )) - 1 ) / (4*BITS(BIT_BLOCK )))*4)\n\
#else\n\
#define BLOCKS_IN_WORLD (((BITS_IN_WORLD + (4*BITS( BIT_BLOCK )) - 1 ) / (4*BITS(BIT_BLOCK )))*4)\n\
#endif\n\
\n\
/****************************************   // added by Uli\n\
  class for pointer to previous state\n\
  ****************************************/\n\
\n\
class state;\n\
\n\
class StatePtr\n\
{\n\
private:\n\
  union {\n\
    state*        sp;   // real pointer\n\
    unsigned long lv;   // state number used in trace info file\n\
  };\n\
\n\
  // StatePtr is a member of the class state, so try to avoid adding\n\
  // data members\n\
\n\
  inline void sCheck();\n\
  inline void lCheck();\n\
\n\
public:\n\
  StatePtr() { sp = 0; }\n\
  StatePtr(state* s);\n\
  StatePtr(unsigned long l);\n\
\n\
  void set(state* s);\n\
  void set(unsigned long l);\n\
  void clear();\n\
  state* sVal();\n\
  unsigned long lVal();\n\
\n\
  StatePtr previous();      // return StatePtr to previous state\n\
  bool isStart();           // check if I point to a startstate\n\
  bool compare(state* s);   // compare the state I point to with s\n\
 \n\
};\n\
\n\
\n\
/****************************************\n\
  class state.\n\
  ****************************************/\n\
// Warning: DO NOT add member variables to this class unless\n\
// you know exactly what you're doing. Since an instance of the\n\
// state class is created for each table entry during\n\
// initialization, adding stuff here will eat lots of memory.\n\
// Uli: this is only true if one does not use hash compaction\n\
\n\
#ifdef HASHC\n\
hash_function *h3;\n\
#endif\n\
\n\
class state\n\
{\n\
public:\n\
  BIT_BLOCK bits[ BLOCKS_IN_WORLD ];\n\
  StatePtr previous;   // state from which this state was reached.\n\
#ifdef HASHC\n\
#ifdef ALIGN\n\
  // Uli: only in the aligned version the hashkeys are stored with the state\n\
  unsigned long hashkeys[3];\n\
#endif\n\
#endif\n\
\n\
  state()\n\
  : previous()\n\
  {\n\
      memset( bits, 0, ( reinterpret_cast< char * >( &previous ) - reinterpret_cast< char * >( &bits ) ) );\n\
  };\n\
  state(state * s) \n\
  {\n\
    StateCopy(this, s);\n\
    memset( reinterpret_cast< char * >( &bits ) + sizeof( bits ), 0,\n\
            ( reinterpret_cast< char * >( &previous ) - reinterpret_cast< char * >( &bits ) ) );\n\
  };\n\
\n\
friend void StateCopy(state * l, state * r);\n\
friend int StateCmp(state * l, state * r);\n\
friend void copy_state(state *& s);\n\
#ifdef HASHC\n\
friend class hash_function;\n\
#endif\n\
//friend unsigned long* hash_function::hash(state*, bool);\n\
// friend bool StateEquivalent(state * l, state * r);   // Uli: not necessary\n\
  \n\
  // get it with Horner\\'s method. \n\
  // size  <= the number of bits in an integer - 1\n\
#ifndef ALIGN\n\
  inline int get(const position *w) const {   // Uli: const added\n\
    unsigned int val, *l;\n\
    l = (unsigned int *)(bits + w->longoffset);\n\
    val = (l[0] & w->mask1) >> w->shift1;\n\
    if (w->mask2)\n\
	val |= (l[1] & w->mask2) << w->shift2;\n\
    return (int)val;\n\
  }\n\
#else\n\
  inline int get(int byteloc) const { return bits[byteloc]; };\n\
  inline int getlong(int byteloc) const {\n\
    unsigned int  val;\n\
    unsigned char *p = (unsigned char *)&bits[byteloc];\n\
    val = *p++;\n\
    val |= *p++ << 8;\n\
    val |= *p++ << 16;\n\
    val |= *p++ << 24;\n\
    return (int)val;\n\
  }\n\
#endif\n\
\n\
  \n\
  // set a field to value \n\
  // size  <= the number of bits in an integer - 1\n\
#ifndef ALIGN\n\
  inline void set(position *w, int value) {\n\
    unsigned int val, *l;\n\
    l = (unsigned int *)(bits + w->longoffset);\n\
    val = value << w->shift1;\n\
    l[0] = (l[0] & ~w->mask1) | val;\n\
    if (w->mask2) {\n\
      val = (value >> w->shift2) & w->mask2;\n\
      l[1] = (l[1] & ~w->mask2) | val;\n\
    }\n\
  };\n\
#else\n\
  inline void setlong(int byteloc, int value) {\n\
    unsigned char *p = (unsigned char *)&bits[byteloc];\n\
    *p++ = (unsigned)value & 0xff;\n\
    *p++ = ((unsigned)value & 0xff00) >> 8;\n\
    *p++ = ((unsigned)value & 0xff0000) >> 16;\n\
    *p++ = ((unsigned)value & 0xff000000) >> 24;\n\
  };\n\
#endif\n\
  \n\
  // key for hash function, changes by Uli\n\
#ifndef HASHC\n\
  unsigned long hashkey(void) const \n\
  {\n\
    unsigned long sum = 0;\n\
    unsigned long *pt = (unsigned long *)bits;\n\
\n\
    for (int i = BLOCKS_IN_WORLD>>2; i>0; i--) {\n\
      sum += *pt++;\n\
    }\n\
    return sum;\n\
  }\n\
#endif\n\
\n\
  \n\
  // operator== and operator!= only consider the bitvectors,\n\
  // not the other components of a state. \n\
  inline bool operator == (state& other) const\n\
  { return ( memcmp(&bits, &other.bits, BLOCKS_IN_WORLD) == 0); };\n\
  inline bool operator != (state& other) const\n\
  { return ( memcmp(&bits, &other.bits, BLOCKS_IN_WORLD) != 0); };\n\
  \n\
  // scribbles over the current world variables. \n\
  void print();\n\
\n\
  // symmetry reduction\n\
  void Normalize();\n\
\n\
  // multiset reduction\n\
  void MultisetSort();\n\
\n\
};\n\
\n\
/********************\n\
  $Log: mu_statecl.h,v $\n\
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
