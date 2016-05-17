namespace murphi { const char *mu_system_h_str = "\
/* -*- C++ -*-\n\
 * mu_system.h\n\
 * @(#) header defining the environment for the system\n\
 *      to be simulated or verified\n\
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
 * Original Author: C. Norris Ip \n\
 * Created: 19 Oct 94\n\
 *\n\
 * Update:\n\
 *\n\
 */ \n\
\n\
/************************************************************/\n\
\n\
// Uli: added omission probability calculation & printing\n\
\n\
class StateManager\n\
{\n\
  state_set *the_states;  // the set of states found.\n\
  state_queue *queue;     // the queue for active states.\n\
  unsigned long NumStates;\n\
\n\
  // Uli: for omission probability calculation\n\
  long statesCurrentLevel;   // number of states in the level that\n\
                             //  is currently expanded\n\
  long statesNextLevel;      // number of states in the next level\n\
  long currentLevel;         // level that is currently expanded\n\
                             //  (startstates: level 0)\n\
  double pno;   // Pr(particular state not omitted)\n\
\n\
  double harmonic(double n);   // return harmonic number H_n\n\
\n\
public:\n\
  StateManager(bool createqueue, unsigned long NumStates);\n\
  ~StateManager();\n\
\n\
  bool Add(state * s, bool valid, bool permanent);\n\
  bool QueueIsEmpty();\n\
  state * QueueTop();\n\
  state * QueueDequeue();\n\
  unsigned NextRuleToTry();   // Uli: unsigned short -> unsigned\n\
  void NextRuleToTry(unsigned r);\n\
\n\
  // Uli: routines for omission probability calculation & printing\n\
  void CheckLevel();\n\
  void PrintProb();\n\
\n\
  void print_capacity();\n\
  void print_all_states();\n\
  void print_trace(StatePtr p);   // changes by Uli\n\
  void print_trace_aux(StatePtr p);\n\
  unsigned long NumElts();\n\
  unsigned long NumEltsReduced();   // Uli\n\
  unsigned long QueueNumElts();\n\
\n\
};\n\
\n\
// extern class StartStateGenerator;\n\
class StartStateGenerator;\n\
\n\
/************************************************************/\n\
class StartStateManager\n\
{\n\
  static unsigned short numstartstates;\n\
  unsigned short what_startstate; // for info at Error\n\
  StartStateGenerator * generator;\n\
  randomGen random;   // Uli: random number generator\n\
public:\n\
  StartStateManager();\n\
  state * RandomStartState();\n\
  void AllStartStates();\n\
  state * NextStartState();\n\
  state * StartState();\n\
  char * LastStateName();\n\
  char * StateName(StatePtr p);   // changes by Uli\n\
};\n\
\n\
// extern class NextStateGenerator;\n\
class NextStateGenerator;\n\
\n\
/************************************************************/\n\
class RuleManager\n\
{\n\
  unsigned what_rule;       // for execution and info at Error\n\
  unsigned long rules_fired;\n\
  unsigned long * NumTimesFired; /* array for storing the number\n\
				    of times fired for each rule */\n\
  NextStateGenerator * generator;\n\
\n\
  setofrules * EnabledTransition();\n\
  bool AllNextStates(setofrules * fire);\n\
  state * NextState();\n\
  randomGen random;   // Uli: random number generator\n\
\n\
  // Vitaly's additions\n\
  int minp; 	// Minimum priority among all rules applicable\n\
		// in the current state\n\
  // End of Vitaly's additions\n\
\n\
public:\n\
  RuleManager();\n\
  ~RuleManager();\n\
  state * RandomNextState();\n\
  state * SeqNextState();\n\
  bool AllNextStates();\n\
  void ResetRuleNum();\n\
  void SetRuleNum(unsigned r);\n\
  char * LastRuleName();\n\
  unsigned long NumRulesFired();\n\
  void print_rules_information();\n\
  void print_world_to_state(StatePtr p, bool fullstate);   \n\
    // changes by Uli\n\
};\n\
\n\
/************************************************************/\n\
class PropertyManager\n\
{\n\
  unsigned short what_invariant;  // for info at Error\n\
public:\n\
  PropertyManager();\n\
  bool CheckInvariants();\n\
  char * LastInvariantName();\n\
};\n\
\n\
/************************************************************/\n\
class SymmetryManager\n\
{\n\
  state_set *debug_sym_the_states;  // the set of states found without sym.\n\
public:\n\
  SymmetryManager();\n\
};\n\
\n\
/************************************************************/\n\
class POManager // Partial Order\n\
{\n\
  rule_matrix *conflict_matrix;\n\
public:\n\
  POManager();\n\
};\n\
\n\
/************************************************************/\n\
class AlgorithmManager\n\
{\n\
public:\n\
  AlgorithmManager();\n\
  void verify_bfs();\n\
  void verify_dfs();\n\
  void simulate();\n\
};\n\
\n\
/************************************************************/\n\
StartStateManager *StartState;  // manager for all startstate related operation\n\
RuleManager *Rules;             // manager for all rule related operation\n\
PropertyManager *Properties;    // manager for all property related operation\n\
StateManager *StateSet;         // manager for all state related information\n\
SymmetryManager *Symmetry;      // manager for all symmetry information\n\
POManager *PO;                  // manager for all symmetry information\n\
ReportManager *Reporter;        // manager for all diagnostic messages\n\
AlgorithmManager *Algorithm;    // manager for all algorithm related issue\n\
\n\
Error_handler Error;       // general error handler.\n\
argclass *args;            // the record of the arguments.\n\
state *curstate;        // current state at the beginning of the rule-firing\n\
//state *const workingstate = new state;   // Uli: buffer for doing all state\n\
                                           //      manipulation\n\
//world_class theworld;          // the set of global variables.\n\
int category;                  // working on startstate, rule or invariant\n\
\n\
#ifdef HASHC\n\
TraceFileManager* TraceFile;   // Uli: manager for trace info file\n\
#endif\n\
unsigned long NumCurState;     // Uli: number of the current state for trace \n\
                               //      info file\n\
\n\
inline MuGlobal &MuGlobal::get() {\n\
    static __thread MuGlobal *instance = 0;\n\
    if ( !instance ) {\n\
        instance = new MuGlobal;\n\
        instance->world->to_state( NULL );\n\
    }\n\
    return *instance;\n\
}\n\
\n\
/********************\n\
  $Log: mu_system.h,v $\n\
  Revision 1.3  1999/01/29 08:28:09  uli\n\
  efficiency improvements for security protocols\n\
\n\
  Revision 1.2  1999/01/29 07:49:11  uli\n\
  bugfixes\n\
\n\
  Revision 1.4  1996/08/07 18:54:33  ip\n\
  last bug fix on NextRule/SetNextEnabledRule has a bug; fixed this turn\n\
\n\
  Revision 1.3  1996/08/07 01:09:49  ip\n\
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
