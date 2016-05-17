namespace murphi { const char *mu_sym_C_str = "\
/* -*- C++ -*-\n\
 * mu_sym.C\n\
 * @(#) Auxiliary routines related to symmetry in the verifier \n\
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
 */\n\
\n\
/* \n\
 * Original Author: Norris Ip\n\
 * Created Date: 3 Dec 93\n\
 *\n\
 */\n\
\n\
void\n\
SymmetryClass::SetBestResult (int i, state * temp)\n\
{\n\
  if (!BestInitialized) {\n\
    BestPermutedState = *temp;\n\
    BestInitialized = TRUE;\n\
  }\n\
  else {\n\
    switch (StateCmp (temp, &BestPermutedState)) {\n\
    case -1:\n\
      Perm.Add (i);\n\
      BestPermutedState = *temp;\n\
      break;\n\
    case 1:\n\
      Perm.Remove (i);\n\
      break;\n\
    case 0:\n\
      // do nothing\n\
      break;\n\
    default:\n\
      Error.Error (\"funny return value from StateCmp\");\n\
    }\n\
  }\n\
}\n\
void\n\
state::Normalize ()\n\
{\n\
  static SymmetryClass symmetry;\n\
\n\
  symmetry.Normalize (this);\n\
}\n\
\n\
void\n\
state::MultisetSort ()\n\
{\n\
  static SymmetryClass symmetry;\n\
\n\
  symmetry.MultisetSort (this);\n\
}\n\
\n\
/********************\n\
  $Log: mu_sym.C,v $\n\
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
