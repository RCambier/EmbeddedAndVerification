namespace murphi { const char *mu_util_C_str = "\
/* -*- C++ -*-\n\
 * mu_util.C\n\
 * @(#) Auxiliary routines for the driver for Murphi verifiers.\n\
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
  There are four categories:\n\
  1) utility functions (not in any class)\n\
  2) mu__int and mu__boolean\n\
  3) world_class\n\
  4) timer (not in any class)\n\
  5) setofrules\n\
  6) rule_matrix\n\
  7) random number generator\n\
  ****************************************/\n\
\n\
/****************************************\n\
  Utility functions\n\
  ****************************************/\n\
\n\
/* g++ seems not to know about strstr, so we\\'ll write our own. Bleah. */\n\
/* Bad code, bad! But it\\'s not on the critical path. */\n\
/* Copied from Andreas. */\n\
const char* \n\
StrStr(const char* super, const char* sub ) {\n\
  int i, j;\n\
  for( i=0; super[i]; i++  ) {\n\
    for( j=0; sub[j] != '\\0'; j++  )\n\
      {\n\
        if ( super[i+j] != sub[j] ) break;\n\
      }\n\
    if ( j == strlen(sub) )\n\
      return &(super[i]);       /* Match. */\n\
  }\n\
  return NULL;                  /* No match. */\n\
}\n\
\n\
void \n\
ErrAlloc( void *p )\n\
/* I don\\'t think this actually does anything; we should patch\n\
 * new_handler instead. */\n\
{\n\
  if ( p == NULL )\n\
    { Error.Notrace(\"Unable to allocate memory.\"); }\n\
}\n\
\n\
void \n\
err_new_handler(void)\n\
{\n\
  Error.Notrace(\"Unable to allocate memory.\");\n\
}\n\
\n\
/* we should #include <signal.h> at some point. */   \n\
// Uli: CATCH_DIV has to be defined or undefined depending on compiler\n\
//      and operating system\n\
#ifndef CATCH_DIV\n\
void catch_div_by_zero(...)\n\
#else\n\
void catch_div_by_zero(int)\n\
#endif\n\
{ Error.Error(\"Division by zero.\"); }\n\
\n\
/* From Andreas\\' code. */\n\
bool \n\
IsPrime( unsigned long n )\n\
{\n\
  unsigned long i = 3;\n\
  if ( n < 3 ) return TRUE;\n\
  if ( n % 2 == 0 ) return FALSE;\n\
  while( i * i <= n )\n\
    {\n\
      if( n % i == 0 )\n\
        {\n\
          return FALSE;\n\
        }\n\
      i += 2;\n\
    }\n\
  return TRUE;\n\
}\n\
\n\
unsigned long \n\
NextPrime( unsigned long n )\n\
/* Well, this is only O ( n * sqrt(n) )--and more importantly, it only\n\
 * gets executed once. */\n\
{\n\
  while( !IsPrime(n) )\n\
    {\n\
      n++;\n\
    }\n\
  return n;\n\
}\n\
\n\
unsigned long \n\
NumStatesGivenBytes( unsigned long bytes )\n\
/* From Andreas\\' code.*/\n\
{\n\
  unsigned long exactNumStates = (unsigned long)\n\
    ( (double) bytes * 8 /\n\
      ( state_set::bits_per_state() +\n\
        gPercentActiveStates * 8 * state_queue::BytesForOneState()));\n\
  return NextPrime( exactNumStates );\n\
}\n\
\n\
char *\n\
tsprintf (char *fmt, char *str)\n\
{\n\
  static char temp_buffer[BUFFER_SIZE];\n\
  char *newstr;\n\
  sprintf(temp_buffer, fmt, str);\n\
  newstr = new char[strlen(temp_buffer)+1];\n\
  strcpy(newstr, temp_buffer);\n\
  return newstr;\n\
}\n\
\n\
char *\n\
tsprintf (char *fmt, char *str1, char *str2)\n\
{\n\
  static char temp_buffer[BUFFER_SIZE];\n\
  char *newstr;\n\
  sprintf(temp_buffer, fmt, str1, str2);\n\
  newstr = new char[strlen(temp_buffer)+1];\n\
  strcpy(newstr, temp_buffer);\n\
  return newstr;\n\
}\n\
\n\
char *\n\
tsprintf (char *fmt, ...)\n\
/* sprintf's the arguments into dynamically allocated memory.  Returns the\n\
 * dynamically allocated string. */\n\
{\n\
  static char temp_buffer[BUFFER_SIZE]; /* hope that\\'s enough. */\n\
  va_list argp;\n\
  char *retval;\n\
  \n\
  va_start(argp,fmt);\n\
  vsprintf(temp_buffer, fmt, argp);\n\
  va_end(argp);\n\
  \n\
  if (strlen(temp_buffer) >= BUFFER_SIZE)\n\
    Error.Error(\"Temporary buffer overflow.\\n\\\n\
Please increase the constant BUFFER_SIZE in file mu_verifier.h and recompile your program\\n\\\n\
(you may also reduce the length of expression by using function call.\");\n\
\n\
  retval = new char[ strlen(temp_buffer) + 1 ]; /* + 1 for the \\0. */\n\
  strcpy(retval, temp_buffer);\n\
  return ( retval );\n\
}\n\
\n\
/****************************************\n\
  The base class for a value\n\
  ****************************************/\n\
\n\
/* Now that we\\'ve defined the state, we can go back and write\n\
 * mu__int::to_state() and mu__int::from_state(). */\n\
\n\
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
// mu__int\n\
\n\
#ifndef NO_RUN_TIME_CHECKING\n\
void mu__int::boundary_error(int val) const\n\
{\n\
  Error.Error(\"%d not in range for %s.\", val, name);\n\
}\n\
\n\
int mu__int::undef_error() const\n\
{\n\
  switch (category) {\n\
  case STARTSTATE:\n\
    Error.Error(\"The undefined value at %s is referenced\\n\\tin startstate:\\n\\t%s\",\n\
		name, StartState->LastStateName());\n\
  case CONDITION:\n\
    Error.Error(\"The undefined value at %s is referenced\\n\\tin the guard of the rule:\\n\\t%s\",\n\
		name, Rules->LastRuleName());\n\
  case RULE:\n\
    Error.Error(\"The undefined value at %s is referenced\\n\\tin rule:\\n\\t%s\",\n\
		name, Rules->LastRuleName());\n\
  case INVARIANT:\n\
    Error.Error(\"The undefined value at %s is referenced\\n\\tin invariant:\\n\\t%s\",\n\
		name, Properties->LastInvariantName());\n\
    \n\
  default:	\n\
    Error.Error(\"The undefined value at %s is referenced\\n\\tat a funny time\\nnot recognized by the verifier.\", name);\n\
  }\n\
  return lb;\n\
};\n\
#endif\n\
\n\
// Uli: simplified print_diff\n\
void \n\
mu__int::print_diff( state *prevstate )\n\
{\n\
  /* We assume that prevstate is not null. */\n\
#ifndef ALIGN\n\
  if (prevstate->get(&where) != workingstate->get(&where))\n\
#else\n\
  if (prevstate->get(byteOffset) != workingstate->get(byteOffset))\n\
#endif\n\
    print();\n\
}\n\
\n\
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
// mu__long\n\
\n\
// Uli: simplified print_diff\n\
void \n\
mu__long::print_diff( state *prevstate )\n\
{\n\
  /* We assume that prevstate is not null. */\n\
#ifndef ALIGN\n\
  if (prevstate->get(&where) != workingstate->get(&where))\n\
#else\n\
  if (prevstate->getlong(byteOffset) != workingstate->getlong(byteOffset))\n\
#endif\n\
    print();\n\
}\n\
\n\
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
// mu_0_boolean\n\
\n\
char *mu_0_boolean::values[] = {\"false\", \"true\"};\n\
\n\
void mu_0_boolean::Permute(PermSet& Perm, int i) {};\n\
void mu_0_boolean::SimpleCanonicalize(PermSet& Perm) {};\n\
void mu_0_boolean::Canonicalize(PermSet& Perm) {};\n\
void mu_0_boolean::SimpleLimit(PermSet& Perm) {};\n\
void mu_0_boolean::ArrayLimit(PermSet& Perm) {};\n\
void mu_0_boolean::Limit(PermSet& Perm) {};\n\
\n\
\n\
/****************************************\n\
  world_class declarations\n\
  ****************************************/\n\
\n\
/* in the same vein, now we can write world_class::get_state(). */\n\
state *world_class::getstate() {return NULL;};   // changed by Uli\n\
\n\
/***************************\n\
  Timer\n\
  ***************************/\n\
\n\
// changed by Uli, ideas from Liz \n\
//   this way of getting the runtime seems much more portable than\n\
//   the old way\n\
\n\
#include <sys/times.h>          // for times() and related structs\n\
#include <unistd.h>             // for sysconf()\n\
\n\
// Returning a double here is better for Unix, since otherwise\n\
// a long would only suffice for about 30 minutes.\n\
\n\
double SecondsSinceStart( void ) {\n\
  double retval;\n\
  static double numTicksPerSec = (double)(sysconf(_SC_CLK_TCK));\n\
  static struct tms clkticks;\n\
\n\
  times(&clkticks);     // retrieve the time-usage information\n\
  retval = ((double) clkticks.tms_utime + (double) clkticks.tms_stime)\n\
                / numTicksPerSec;\n\
  if( retval <= 0.1 ) /* Avoid div-by-zero errors. */\n\
    {\n\
      retval = 0.1;\n\
    }\n\
  return retval;\n\
}\n\
\n\
\n\
/****************************************\n\
  class setofrules\n\
  ****************************************/\n\
\n\
setofrules interset(setofrules rs1, setofrules rs2)\n\
{\n\
  setofrules retval;\n\
  for ( unsigned r=0; r<numrules; r++)   // Uli: unsigned short -> unsigned\n\
    {\n\
      if ( rs1.in(r) && rs2.in(r) )\n\
	retval.add(r);\n\
      else\n\
	retval.remove(r);\n\
    }\n\
  return retval;\n\
}\n\
\n\
setofrules different(setofrules rs1, setofrules rs2)\n\
{\n\
  setofrules retval;\n\
  for ( unsigned r=0; r<numrules; r++)\n\
    {\n\
      if ( rs1.in(r) && !rs2.in(r) )\n\
	retval.add(r);\n\
      else\n\
	retval.remove(r);\n\
    }\n\
  return retval;\n\
}\n\
\n\
bool subset(setofrules rs1, setofrules rs2)\n\
{\n\
  for ( unsigned r=0; r<numrules; r++)\n\
    if ( rs1.in(r) && !rs2.in(r) )\n\
      return FALSE;\n\
  return TRUE;\n\
}  \n\
\n\
\n\
/***************************   // added by Uli\n\
  random number generator\n\
  ***************************/\n\
// see Jain, The Art of Computer Systems Performance Analysis, pg.442 and 452\n\
// generator: x[n] = 7^5 x[n-1] mod(2^31-1), period: 2^31-2\n\
\n\
#include <sys/time.h>\n\
\n\
randomGen::randomGen()\n\
{\n\
  struct timeval tp;\n\
  struct timezone tzp;\n\
\n\
  // select a \"random\" seed\n\
  gettimeofday(&tp, &tzp);\n\
  value = ((unsigned long)(tp.tv_sec^tp.tv_usec) * 2654435769ul) >> 1;\n\
  if (value==0) value = 46831694;\n\
}\n\
\n\
unsigned long randomGen::next()\n\
{\n\
  long g;\n\
\n\
  g = 16807 * (value%127773) - 2836 * (value/127773);\n\
  return value = (g>0) ? g : g+2147483647;\n\
}\n\
\n\
\n\
/****************************************\n\
  * 20 Dec 93 Norris Ip: \n\
  added the following to  mu_0_boolean:\n\
        void mu_0_boolean::Permute(PermSet& Perm, int i) {};\n\
        void mu_0_boolean::Canonicalize(PermSet& Perm) {};\n\
        void mu_0_boolean::Limit(PermSet& Perm) {};\n\
  * 28 Feb 94 Norris Ip:\n\
  fixed checking whether variable is initialized.\n\
  * 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
  * 6 April 94 Norris Ip:\n\
  portability -- timer #ifdef __hpux\n\
  * 12 April 94 Norris Ip:\n\
  add information about error in the condition of the rules\n\
  category = CONDITION\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_util.C,v $\n\
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
