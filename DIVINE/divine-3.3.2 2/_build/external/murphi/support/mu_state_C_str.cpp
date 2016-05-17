namespace murphi { const char *mu_state_C_str = "\
/* -*- C++ -*-\n\
 * mu_state.C\n\
 * @(#) Auxiliary routines related to states in the verifier\n\
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
  1) bit vector\n\
  2) class StatePtr and state related stuff\n\
  3) state queue and stack\n\
  4) state set\n\
  ****************************************/\n\
\n\
void\n\
state::print()\n\
{\n\
  theworld.print();\n\
};\n\
\n\
/****************************************\n\
  Bit vector - copied straight from Andreas. \n\
  ****************************************/\n\
dynBitVec::dynBitVec( unsigned long nBits )\n\
: numBits( nBits )\n\
{\n\
  v = new unsigned char[ NumBytes() ]; /* Allocate and clear vector. */\n\
  ErrAlloc(v);\n\
  memset( v, 0, NumBytes() );\n\
};\n\
\n\
dynBitVec::~dynBitVec()\n\
{\n\
  delete[ OLD_GPP(NumBytes()) ] v; // should be delete[].\n\
}\n\
\n\
\n\
/****************************************\n\
  class StatePtr and state related stuff.\n\
  ****************************************/\n\
\n\
inline void StatePtr::sCheck() {\n\
#ifdef HASHC\n\
  if (args->trace_file.value)\n\
    Error.Notrace(\"Internal: Illegal Access to StatePtr.\");\n\
#endif\n\
}\n\
\n\
inline void StatePtr::lCheck() {\n\
#ifdef HASHC\n\
  if (!args->trace_file.value)\n\
    Error.Notrace(\"Internal: Illegal Access to StatePtr.\");\n\
#endif\n\
}\n\
\n\
StatePtr::StatePtr(state* s) { sCheck(); sp=s; }\n\
StatePtr::StatePtr(unsigned long l) { lCheck(); lv=l; }\n\
\n\
void StatePtr::set(state* s) { sCheck(); sp=s; }\n\
void StatePtr::set(unsigned long l) { lCheck(); lv=l; }\n\
void StatePtr::clear() {\n\
#ifdef HASHC\n\
  if (args->trace_file.value) \n\
    lv=0;\n\
  else\n\
#endif \n\
    sp=NULL;\n\
} \n\
state* StatePtr::sVal() { sCheck(); return sp; }\n\
unsigned long StatePtr::lVal() { lCheck(); return lv; }\n\
\n\
StatePtr StatePtr::previous() {   // return StatePtr to previous state\n\
#ifdef HASHC\n\
  if (args->trace_file.value)\n\
    return TraceFile->read(lv)->previous;\n\
  else\n\
#endif\n\
    return sp->previous.sp;\n\
}\n\
\n\
bool StatePtr::isStart() {   // check if I point to a startstate\n\
#ifdef HASHC\n\
  if (args->trace_file.value) {\n\
    if (TraceFile->read(lv)->previous==0) return TRUE;\n\
    return FALSE;\n\
  }\n\
  else \n\
#endif\n\
  {\n\
    if (sp->previous.sp==NULL) return TRUE;\n\
    return FALSE;\n\
  }\n\
}\n\
\n\
bool StatePtr::compare(state* s) {   // compare the state I point to with s\n\
#ifdef HASHC\n\
  if (args->trace_file.value) {\n\
    unsigned long *key = h3->hash(s, FALSE);\n\
    unsigned long c1 = key[1] &\n\
      ((~0UL) << (args->num_bits.value>32 ? 0 : 32-args->num_bits.value));\n\
    unsigned long c2 = key[2] &\n\
      (args->num_bits.value>32 ? (~0UL)<<(64-args->num_bits.value) : 0UL);\n\
\n\
    return ( c1==TraceFile->read(lv)->c1 &&\n\
             c2==TraceFile->read(lv)->c2 );\n\
  }\n\
  else\n\
#endif\n\
    return (StateCmp(sp,s)==0);\n\
}\n\
\n\
\n\
void \n\
StateCopy(state * l, state * r)\n\
// Uli: uses default assignment operator\n\
{\n\
  *l = *r;\n\
}\n\
\n\
int \n\
StateCmp(state * l, state * r)\n\
{\n\
  int i = BLOCKS_IN_WORLD/4;\n\
  register int *d = (int *)l->bits, *s = (int *)r->bits;\n\
\n\
  while (i--)\n\
      if( *d > *s)\n\
	  return 1;\n\
      else if( *d++ < *s++)\n\
	  return -1;\n\
  return 0;\n\
}\n\
\n\
void \n\
copy_state(state *& s)\n\
{\n\
  state *h;\n\
\n\
  if ( (h = new state) == NULL )\n\
    Error.Notrace\n\
      (\"New failed. Swap space probably too small for state queue.\");\n\
  *h = *s;\n\
  s = h;\n\
}\n\
\n\
bool \n\
StateEquivalent(state * l, StatePtr r)\n\
{\n\
  return match(l, r);\n\
}\n\
\n\
/****************************************\n\
  class state_queue for searching the state space.\n\
  ****************************************/\n\
state_queue::state_queue( unsigned long mas )\n\
:max_active_states(mas), num_elts(0), front(0), rear(0)\n\
{\n\
  stateArray = new state*[ max_active_states ];\n\
\n\
  for ( long i = 0; i < max_active_states; i++)   // Uli: avoid bzero\n\
    stateArray[i] = NULL;\n\
};\n\
\n\
state_queue::~state_queue()\n\
{\n\
  delete[ OLD_GPP(max_active_states) ] stateArray; // Should be delete[].\n\
}\n\
\n\
int \n\
state_queue::BytesForOneState( void ) {\n\
  \n\
#ifdef VER_PSEUDO\n\
  // Pseudo ver: ptr + malloced state + approx. malloc&new overhead.\n\
  return sizeof(state*) + sizeof(state) + 8;    \n\
#else\n\
  return sizeof(state*);				/* Full ver: only a ptr to state. */\n\
#endif\n\
}\n\
\n\
void \n\
state_queue::Print( void )\n\
{\n\
  unsigned long i;\n\
  unsigned long ind = front;\n\
  for( i = 1; i < num_elts; i++ )\n\
    {\n\
      // convert to print in unsigned long format?\n\
      cout << \"State \" << i << \" [\" << ind << \"]:\\n\";\n\
      stateArray[ ind ]->print();\n\
      ind = (ind + 1) % max_active_states;\n\
    }\n\
}\n\
\n\
void \n\
state_queue::enqueue( state* e )\n\
{\n\
  if( num_elts < max_active_states )\n\
    {\n\
      stateArray[ rear ] = e;\n\
      rear = (rear + 1) % max_active_states;\n\
      num_elts++;\n\
    }\n\
  else\n\
    {\n\
      Error.Notrace( \"Internal Error: Too many active states.\" );\n\
    }\n\
} \n\
\n\
state* \n\
state_queue::dequeue( void )\n\
{ \n\
  state* retval;\n\
  if( num_elts > 0 )\n\
    {\n\
      retval = stateArray[ front ];\n\
      front = (front + 1) % max_active_states;\n\
      num_elts--;\n\
    }\n\
  else\n\
    {\n\
      Error.Notrace( \"Internal: Attempt to dequeue from empty state queue.\", \"\", \"\" );\n\
    }\n\
  return retval;\n\
}\n\
\n\
state* \n\
state_queue::top( void )\n\
{\n\
  if ( num_elts>0 )\n\
    {\n\
      return stateArray[ front ];\n\
    }\n\
  else\n\
    {\n\
      Error.Notrace( \"Internal: Attempt to top() empty state queue.\", \"\", \"\" );\n\
      return NULL;\n\
    }\n\
}\n\
\n\
void\n\
state_stack::enqueue( state* e )\n\
{\n\
  if( num_elts < max_active_states )\n\
    {\n\
      front = front == 0 ? max_active_states-1 : front-1;\n\
      stateArray[ front ] = e;\n\
      nextrule_to_try[ front ] = 0;\n\
      num_elts++;\n\
    }\n\
  else\n\
    {\n\
      Error.Notrace( \"Internal: Too many active states.\" );\n\
    }\n\
}\n\
\n\
/****************************************   // changes by Uli\n\
  The Stateset implementation for recording all the states found.\n\
  ****************************************/\n\
\n\
int state_set::bits_per_state() \n\
{\n\
#ifndef HASHC\n\
  return 8*sizeof(state);\n\
#else\n\
  return args->num_bits.value;\n\
#endif\n\
}\n\
  \n\
state_set::state_set (unsigned long table_size )\n\
: table_size (table_size), num_elts(0), num_elts_reduced(0), num_collisions(0)\n\
{\n\
#ifndef HASHC\n\
  table = new state [table_size];\n\
#else \n\
  assert (sizeof(Unsigned32)==4);   // the implementation is pretty depen-\n\
                                    // dent on the 32 bits\n\
  unsigned long size =\n\
    (unsigned long)((double)table_size*args->num_bits.value/32) + 3;\n\
    // higher precision necessary to avoid overflow\n\
    // two extra elements needed in table\n\
  table = new Unsigned32 [size];\n\
  for (unsigned long i=0; i<size; i++)\n\
    table[i]=0UL;\n\
#endif\n\
  Full = new dynBitVec ( table_size );\n\
}\n\
\n\
state_set::~state_set()\n\
{\n\
  delete[] table;   // only works for newer g++ versions\n\
  delete Full;\n\
}\n\
\n\
// Uli: the two following routines were deleted because they were not called\n\
//      any more and required changes\n\
//void state_set::clear_state_set()\n\
//void copy_state_set( state_set * set1, state_set * set2)\n\
\n\
bool \n\
state_set::simple_was_present( state *& in, bool valid, bool permanent )\n\
/* changes in to point to the first state found with that pattern. */\n\
/* returns true iff the state was present in the hash table;\n\
 * Otherwise, returns false and inserts the state. */\n\
/* Algorithms directly from Andreas\\' code. He cites CLR 235, 236. */\n\
// Uli: pitfall: shift operators yield undefined values if the right\n\
//               operand is equal to the length in bits of the left\n\
//               operand (see ARM, pg.74)\n\
// Uli: table_size must be prime\n\
{\n\
#ifndef HASHC\n\
  unsigned long key = in->hashkey();\n\
  unsigned long h1 = key % table_size;\n\
  unsigned long h2 = 1 + key % ( table_size - 1 );\n\
  unsigned long h = h1;\n\
#else\n\
  unsigned long *key = h3->hash(in, valid);\n\
  unsigned long h1 = key[0] % table_size;\n\
  unsigned long h2;\n\
  register unsigned long h = h1;\n\
  register unsigned long num_bits = args->num_bits.value;\n\
  register unsigned long mask1 = (~0UL) << (num_bits>32 ? 0 : 32-num_bits);\n\
  register unsigned long mask2 = num_bits>32 ? (~0UL)<<(64-num_bits) : 0UL;\n\
  register unsigned long addr, offset;\n\
  register unsigned long c1 = key[1]&mask1;\n\
  register unsigned long c2 = key[2]&mask2;\n\
  register unsigned long t1, t2;\n\
#endif\n\
\n\
#ifdef VER_PSEUDO\n\
  if( is_empty(h) )\n\
    {\n\
      Full->set(h);\n\
      num_elts++;\n\
      return FALSE;\n\
    }\n\
  return TRUE;\n\
\n\
#else\n\
  unsigned long probe = 0;\n\
\n\
#ifndef HASHC   \n\
// no hash compaction, uses double hashing\n\
\n\
  bool empty, equal= FALSE;\n\
\n\
  while ( !(empty = is_empty(h)) &&\n\
	  !(equal = ( *in == table[h] )) &&\n\
	  ( probe < table_size ) )\n\
    {\n\
      h = (h1 + probe * h2) % table_size;   // double hashing\n\
      num_collisions++;\n\
      probe++;\n\
    }\n\
  if (empty)  /* Go ahead and insert the element. */\n\
    {\n\
      table[h] = *in;\n\
      in = &table[h];\n\
      Full->set(h);\n\
      num_elts++;\n\
      return FALSE;\n\
    }\n\
  else if (equal)\n\
    {\n\
      in = &table[h];\n\
      return TRUE;\n\
    }\n\
  else\n\
    {\n\
      Error.Notrace(\"Closed hash table full.\");\n\
      return FALSE; /* it doesn\\'t matter, but it shuts up g++. */\n\
    }\n\
\n\
#else   \n\
// hash compaction, uses ordered hashing\n\
// the state-insertion is done in two steps: search and insertion\n\
\n\
  // search - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  h2 = 1 + c1 % (table_size-1);   // calculation uses compressed value\n\
\n\
  do \n\
  {\n\
    // calculate address and offset in table\n\
    // 32 bit arithmetic not sufficient and may cause overflow\n\
    // addr = (h*num_bits) / 32\n\
    // offset = (h*num_bits) % 32\n\
    offset = (h&0xffffUL)*num_bits;\n\
    addr = (((h>>16)*num_bits)<<11) + (offset>>5);\n\
    offset &= 0x1fUL;\n\
\n\
    if (is_empty(h))\n\
      break;   // search unsuccessful\n\
\n\
    // read compressed value from table\n\
    t1 = (table[addr]<<offset | (offset==0 ? 0 : table[addr+1]>>(32-offset))) \n\
         & mask1;\n\
    t2 = (table[addr+1]<<offset | (offset==0 ? 0 : table[addr+2]>>(32-offset))) \n\
         & mask2;\n\
\n\
    if (t1==c1 ? t2 < c2 : t1 < c1)\n\
      break;    // search unsuccessful\n\
    \n\
    if (t1==c1 && t2==c2)\n\
      return TRUE;   // search successful\n\
\n\
    h = (h+h2) % table_size;\n\
    num_collisions++;\n\
    probe++;\n\
    if (probe==table_size)\n\
      Error.Notrace(\"Closed hash table full.\");\n\
  } while (TRUE);\n\
\n\
  // write trace info\n\
  if (args->trace_file.value)\n\
    TraceFile->write(c1, c2, in->previous.lVal());\n\
\n\
  // insertion - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  if (num_elts==table_size)\n\
    Error.Notrace(\"Closed hash table full.\");\n\
\n\
  while ( !is_empty(h) )   // until empty slot found\n\
  {\n\
    if (t1==c1 ? t2 < c2 : t1 < c1) {\n\
      table[addr]   ^= (c1^t1)>>offset;\n\
      table[addr+1] ^= (offset==0 ? 0 : (c1^t1)<<(32-offset))\n\
                       | (c2^t2)>>offset;\n\
      table[addr+2] ^= (offset==0 ? 0 : (c2^t2)<<(32-offset));\n\
      c1 = t1; c2 = t2; \n\
    }\n\
\n\
    h = (h + 1 + c1 % (table_size-1)) % table_size;\n\
    offset = (h&0xffffUL)*num_bits;\n\
    addr = (((h>>16)*num_bits)<<11) + (offset>>5);\n\
    offset &= 0x1fUL;\n\
    t1 = (table[addr]<<offset | (offset==0 ? 0 : table[addr+1]>>(32-offset)))\n\
         & mask1;\n\
    t2 = (table[addr+1]<<offset | (offset==0 ? 0 : table[addr+2]>>(32-offset)))\n\
         & mask2;\n\
  }\n\
\n\
  table[addr]   |= c1>>offset;   // insertion\n\
  table[addr+1] |= (offset==0 ? 0 : c1<<(32-offset)) | c2>>offset;\n\
  table[addr+2] |= (offset==0 ? 0 : c2<<(32-offset));\n\
\n\
  copy_state(in);   // make copy of state\n\
  Full->set(h);\n\
  num_elts++;\n\
  if (permanent)\n\
    num_elts_reduced++;\n\
  return FALSE;\n\
\n\
#endif\n\
\n\
#endif\n\
};\n\
\n\
bool \n\
state_set::was_present( state *& in, bool valid, bool permanent )\n\
{\n\
  if (args->symmetry_reduction.value)\n\
    in->Normalize();\n\
  if (args->multiset_reduction.value\n\
      && !args->symmetry_reduction.value)\n\
      in->MultisetSort();\n\
  return simple_was_present( in, valid, permanent );\n\
}\n\
\n\
void \n\
state_set::print_capacity( void )\n\
{\n\
  cout << \"\\t* The memory allocated for the hash table and state queue is\\n\\t  \";\n\
  if (args->mem.value > 1000000)\n\
    cout << (args->mem.value/1000000) << \" Mbytes.\\n\";\n\
  else\n\
    cout << (args->mem.value/1000) << \" kbytes.\\n\";\n\
\n\
#ifndef HASHC  \n\
  cout <<   \"\\t  With two words of overhead per state, the maximum size of\\n\"\n\
       <<   \"\\t  the state space is \" \n\
       << table_size << \" states.\\n\"\n\
       << \"\\t   * Use option \\\"-k\\\" or \\\"-m\\\" to increase this, if necessary.\\n\"; \n\
#else\n\
  cout <<   \"\\t  With states hash-compressed to \" \n\
       << args->num_bits.value << \" bits, the maximum size of\\n\"\n\
       <<   \"\\t  the state space is \" \n\
       << table_size << \" states.\\n\"\n\
       << \"\\t   * Use option \\\"-k\\\" or \\\"-m\\\" to increase this, if necessary.\\n\"; \n\
#endif\n\
}\n\
\n\
/****************************************\n\
  Modification:\n\
  1) 1 Dec 93 Norris Ip: \n\
  check -sym option when checking was_present()\n\
  add StateCmp(state l, state r)\n\
  2) 24 Feb 94 Norris Ip:\n\
  added -debugsym option to run two hash tables in parallel\n\
  for debugging purpose\n\
  3) 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_state.C,v $\n\
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
"; }
