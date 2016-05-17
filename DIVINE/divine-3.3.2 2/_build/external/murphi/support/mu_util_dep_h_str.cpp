namespace murphi { const char *mu_util_dep_h_str = "\
/* -*- C++ -*-\n\
 * mu_util_dep.h\n\
 * @(#) part II of the header for Auxiliary routines for the driver \n\
 * for Murphi verifiers: routines depend on constants declared\n\
 * in the middle of the compiled program.\n\
 *      RULES_IN_WORLD\n\
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
  There are 2 groups of declarations:\n\
  1) setofrule and sleepset\n\
  2) rule_matrix\n\
  ****************************************/\n\
\n\
/****************************************\n\
  class setofrule and sleepset\n\
  require RULES_IN_WORLD\n\
  ****************************************/\n\
\n\
#define BLOCKS_IN_SETOFRULES ( (RULES_IN_WORLD + BITS( BIT_BLOCK ) - 1 ) / \\\n\
			  BITS( BIT_BLOCK ))\n\
\n\
/* RULES_IN_WORLD gets defined by the generated code. */\n\
/* The extra addition is there so that we round up to the greater block. */\n\
     \n\
class setofrules\n\
{\n\
protected:\n\
  BIT_BLOCK bits[BLOCKS_IN_SETOFRULES];\n\
  unsigned NumRules;   // Uli: unsigned short -> unsigned\n\
\n\
  int Index(int i) const { return i / BITS( BIT_BLOCK ); };\n\
  int Shift(int i) const { return i % BITS( BIT_BLOCK ); };\n\
  int Get1(int i) const { return ( bits[ Index(i) ] >> Shift(i) ) & 1; };\n\
  void Set1(int i, int val) /* Set bit i to the low bit of val. */\n\
  {\n\
    if ( (val & 1) != 0 )\n\
      bits[ Index(i) ] |= ( 1 << Shift(i));\n\
    else \n\
      bits [ Index(i) ] &= ~( 1 << Shift(i));\n\
  };\n\
\n\
public:\n\
\n\
  // set of rules manipulation\n\
friend setofrules interset(setofrules rs1, setofrules rs2);\n\
friend setofrules different(setofrules rs1, setofrules rs2);\n\
friend bool subset(setofrules rs1, setofrules rs2);\n\
\n\
  // conflict set manipulation\n\
friend setofrules conflict(unsigned rule);\n\
\n\
  setofrules() \n\
  : NumRules(0)\n\
  { for (int i=0; i<BLOCKS_IN_SETOFRULES; i++) bits[i]=0;};\n\
\n\
  virtual ~setofrules() {};\n\
\n\
  bool in(int rule) const { return (bool) Get1(rule); };\n\
  void add(int rule) \n\
  {\n\
    if (!in(rule))\n\
      {\n\
	Set1(rule,TRUE); \n\
	NumRules++;\n\
      }\n\
  };\n\
  void remove(int rule)\n\
  { \n\
    if (in(rule))\n\
      {\n\
	Set1(rule,FALSE); \n\
	NumRules--;\n\
      }\n\
  }\n\
  bool nonempty() \n\
  {\n\
    return (NumRules!=0);\n\
  };\n\
  int size()\n\
  { \n\
    return NumRules;\n\
  };\n\
  void print() \n\
  { \n\
    cout << \"The set of rules =\\t\";\n\
    for (int i=0; i<RULES_IN_WORLD; i++) \n\
      cout << (Get1(i)?1:0) << ',';\n\
    cout << \"\\n\";\n\
  };\n\
\n\
  // for simulation \n\
  void removeall()\n\
  { \n\
    for (int i=0; i<RULES_IN_WORLD; i++) \n\
      Set1(i,FALSE);\n\
    NumRules = 0;\n\
  };\n\
\n\
  // for simulation \n\
  void includeall()\n\
  { \n\
    for (int i=0; i<RULES_IN_WORLD; i++) \n\
      Set1(i,TRUE);\n\
    NumRules = RULES_IN_WORLD;\n\
  };\n\
  unsigned getnthrule(unsigned rule)\n\
  {\n\
    unsigned r=0;\n\
    int i=0;\n\
    while (1)\n\
      if (Get1(i) && r==rule)\n\
	{ Set1(i,FALSE); NumRules--; return (unsigned) i; }\n\
      else if (Get1(i))\n\
	{ i++; r++; }\n\
      else\n\
	{ i++; } \n\
  };\n\
};\n\
\n\
/****************************************\n\
  1) 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_util_dep.h,v $\n\
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
