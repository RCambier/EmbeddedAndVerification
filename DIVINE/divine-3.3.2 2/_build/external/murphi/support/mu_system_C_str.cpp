namespace murphi { const char *mu_system_C_str = "\
/* -*- C++ -*-\n\
 * mu_system.C\n\
 * @(#) procedure for anaylsing the system \n\
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
/* StateManager */\n\
/************************************************************/\n\
StateManager::StateManager(bool createqueue, unsigned long NumStates)\n\
: NumStates(NumStates),\n\
  statesCurrentLevel(0), statesNextLevel(0), currentLevel(0),\n\
  pno(1.0)\n\
{\n\
  if (createqueue) \n\
    { \n\
      queue = new state_queue((unsigned long) (gPercentActiveStates * NumStates) );\n\
    }\n\
  else \n\
    { \n\
      queue = new state_stack((unsigned long) (gPercentActiveStates * NumStates) );\n\
    }\n\
  the_states = new state_set(NumStates);\n\
}\n\
\n\
StateManager::~StateManager()\n\
{\n\
  if (queue != NULL) delete queue;\n\
  if (the_states != NULL) delete the_states;\n\
}\n\
\n\
bool StateManager::Add(state * s, bool valid, bool permanent)\n\
{\n\
  if ( !the_states->was_present(s, valid, permanent) )\n\
    {\n\
      // Uli: invariant check moved here\n\
      if (!Properties->CheckInvariants()) {\n\
        curstate = s;\n\
#ifdef HASHC\n\
        if (args->trace_file.value)\n\
          NumCurState = TraceFile->numLast();\n\
#endif\n\
        Error.Deadlocked(\"Invariant \\\"%s\\\" failed.\",Properties->LastInvariantName());\n\
      }\n\
 \n\
      if ( args->trace_all.value ) Reporter->print_trace_all();\n\
\n\
      statesNextLevel++;\n\
      queue->enqueue(s);\n\
      Reporter->print_progress();\n\
      return TRUE;\n\
    }\n\
  else\n\
    return FALSE;\n\
}\n\
\n\
bool StateManager::QueueIsEmpty()\n\
{\n\
  return queue->isempty();\n\
}\n\
\n\
state * StateManager::QueueTop()\n\
{\n\
  return queue->top();\n\
}\n\
\n\
state * StateManager::QueueDequeue()\n\
{\n\
  return queue->dequeue();\n\
}\n\
\n\
unsigned StateManager::NextRuleToTry()   // Uli: unsigned short -> unsigned\n\
{\n\
  return queue->NextRuleToTry();\n\
}\n\
\n\
void StateManager::NextRuleToTry(unsigned r)\n\
{\n\
  queue->NextRuleToTry(r);\n\
}\n\
\n\
// -------------------------------------------------------------------------\n\
// Uli: added omission probability calculation & printing\n\
\n\
#ifdef HASHC\n\
\n\
#include <math.h>\n\
\n\
double StateManager::harmonic(double n)\n\
// return harmonic number H_n\n\
{\n\
  return (n<1) ? 0 :\n\
                 log(n) + 0.577215665 + 1/(2*n) - 1/(12*n*n);\n\
}\n\
\n\
void StateManager::CheckLevel()\n\
// check if we are done with the level currently expanded\n\
{\n\
  static double p = 1.0;    // current bound on state omission probability\n\
  static double l = pow(2, double(args->num_bits.value));   // l=2^b\n\
  static double k = -1;       // sum of the number of states - 1\n\
  static double m = NumStates;   // size of the state table\n\
\n\
  if (--statesCurrentLevel <= 0)\n\
  // all the states of the current level have been expanded\n\
  {\n\
    // proceed to next level\n\
    statesCurrentLevel = statesNextLevel;\n\
    statesNextLevel = 0;\n\
\n\
    // check if there are states in the following level\n\
    if (statesCurrentLevel!=0)\n\
    {\n\
      currentLevel++;\n\
\n\
      // calculate p_k with equation (2) from FORTE/PSTV paper for\n\
      // the following level\n\
      k += statesCurrentLevel;\n\
      double pk = 1 - 2/l * (harmonic(m+1) - harmonic(m-k))\n\
                  + ((2*m)+k*(m-k)) / (m*l*(m-k+1));\n\
      pno *= pk;\n\
    }\n\
  }\n\
}\n\
\n\
void StateManager::PrintProb()\n\
{\n\
  // calculate Pr(not even one omission) with equation (12) from CHARME\n\
  //  paper\n\
  double l = pow(2,double(args->num_bits.value));\n\
  double m = NumStates;\n\
  double n = the_states->NumElts();\n\
  double exp = (m+1) * (harmonic(m+1) - harmonic(m-n+1)) - n;\n\
  double pNO = pow(1-1/l, (m+1) * (harmonic(m+1) - harmonic(m-n+1)) - n);\n\
\n\
  // print omission probabilities\n\
  cout.precision(6);\n\
  cout << \"Omission Probabilities (caused by Hash Compaction):\\n\\n\"\n\
       << \"\\tPr[even one omitted state]    <= \" << 1-pNO << \"\\n\";\n\
  if (args->main_alg.mode == argmain_alg::Verify_bfs)\n\
    cout << \"\\tPr[even one undetected error] <= \" << 1-pno << \"\\n\"\n\
         << \"\\tDiameter of reachability graph: \" \n\
           << currentLevel-1 << \"\\n\\n\";   \n\
           // remark: startstates had incremented the currentLevel counter\n\
  else\n\
    cout << \"\\n\";\n\
}\n\
\n\
#endif\n\
// -------------------------------------------------------------------------\n\
\n\
void StateManager::print_capacity()\n\
{\n\
  if (  args->main_alg.mode == argmain_alg::Verify_dfs \n\
	|| args->main_alg.mode == argmain_alg::Verify_bfs)\n\
    {\n\
      cout << \"\\nMemory usage:\\n\\n\";\n\
      cout << \"\\t* The size of each state is \" << BITS_IN_WORLD << \" bits \"\n\
	   << \"(rounded up to \" << BLOCKS_IN_WORLD << \" bytes).\\n\";\n\
      the_states->print_capacity();\n\
      queue->print_capacity();\n\
    }\n\
}\n\
\n\
void StateManager::print_all_states()\n\
{\n\
  the_states->print();\n\
}\n\
\n\
unsigned long StateManager::NumElts()\n\
{ \n\
  return the_states->NumElts();\n\
} \n\
\n\
unsigned long StateManager::NumEltsReduced()\n\
{\n\
  return the_states->NumEltsReduced();\n\
}\n\
\n\
unsigned long StateManager::QueueNumElts()\n\
{ \n\
  return queue->NumElts();\n\
}\n\
\n\
void StateManager::print_trace_aux(StatePtr p)   // changes by Uli\n\
{\n\
  state original;\n\
  char *s;\n\
  \n\
  if (p.isStart())\n\
    {\n\
      // this is a startstate\n\
      // expand it into global variable `theworld`\n\
      // StateCopy(workingstate, s);   // Uli: workingstate is set in \n\
                                       //      StateName()\n\
\n\
      // output startstate\n\
      cout << \"Startstate \"\n\
 	   << (s=StartState->StateName(p))\n\
 	   << \" fired.\\n\";\n\
      delete[] s;   // Uli: avoid memory leak\n\
      theworld.print();\n\
      cout << \"----------\\n\\n\";\n\
    }\n\
  else\n\
    {\n\
      // print the prefix\n\
      print_trace_aux(p.previous());\n\
      \n\
      // print the next state, which should be equivalent to state s\n\
      // and set theworld to that state.\n\
      // FALSE: no need to print full state\n\
      Rules->print_world_to_state(p, FALSE);\n\
    }\n\
}\n\
\n\
void StateManager::print_trace(StatePtr p)\n\
{\n\
  // print the prefix \n\
  if (p.isStart())\n\
    {\n\
      print_trace_aux(p);\n\
    }\n\
  else\n\
    {\n\
      print_trace_aux(p.previous());\n\
      \n\
      // print the next state, which should be equivalent to state s\n\
      // and set theworld to that state.\n\
      // TRUE: print full state please;\n\
      Rules->print_world_to_state(p, TRUE);\n\
    }\n\
}\n\
\n\
\n\
/************************************************************/\n\
/* StartStateManager */\n\
/************************************************************/\n\
StartStateManager::StartStateManager()\n\
{\n\
  generator = new StartStateGenerator;\n\
}\n\
\n\
state * \n\
StartStateManager::RandomStartState()\n\
{\n\
  what_startstate = (unsigned short)(random.next() % numstartstates); \n\
  return StartState();\n\
}\n\
\n\
void \n\
StartStateManager::AllStartStates()\n\
{\n\
  state *nextstate = NULL;\n\
\n\
  for(what_startstate=0; what_startstate<numstartstates; what_startstate++)\n\
    {\n\
      nextstate = StartState();   // nextstate points to internal data at theworld.getstate()\n\
      (void) StateSet->Add(nextstate, FALSE, TRUE);\n\
    }\n\
}\n\
\n\
state * \n\
StartStateManager::NextStartState()\n\
{\n\
  static int next_startstate=0;\n\
  if (next_startstate >= numstartstates) return NULL;\n\
  what_startstate = next_startstate++;\n\
  return StartState();\n\
}\n\
\n\
state * \n\
StartStateManager::StartState()\n\
{\n\
  state *next_state = NULL;\n\
  \n\
  category = STARTSTATE;\n\
\n\
  // preparation\n\
  theworld.reset();\n\
  \n\
  // fire state rule\n\
  generator->Code(what_startstate);\n\
  \n\
  // print verbose message\n\
  if (args->verbose.value) Reporter->print_fire_startstate();\n\
  \n\
  // Uli: invariant check moved\n\
  \n\
  // Uli: mark as startstate\n\
  workingstate->previous.clear();\n\
\n\
  return workingstate;\n\
}\n\
\n\
char * \n\
StartStateManager::LastStateName()\n\
{\n\
  return generator->Name(what_startstate);\n\
}\n\
\n\
char * \n\
StartStateManager::StateName(StatePtr p)\n\
{\n\
  state nextstate;\n\
  if (!p.isStart()) Error.Notrace(\"Internal: Cannot find startstate name for non startstate\");\n\
  for(what_startstate=0; what_startstate<numstartstates; what_startstate++)\n\
    {\n\
      StartState();\n\
      StateCopy(&nextstate, workingstate);\n\
\n\
      if (StateEquivalent(&nextstate, p))\n\
	return LastStateName();\n\
    }\n\
\n\
//  Norris: it is very funny, but the following code is supposed to work, but it doesn't\n\
//\n\
//   state * nextstate;\n\
//   for(what_startstate=0; what_startstate<numstartstates; what_startstate++)\n\
//     {\n\
//       nextstate = StartState();                  // nextstate points to internal data at theworld.getstate()\n\
//       if (p.compare(nextstate))\n\
// 	return LastStateName();\n\
//     }\n\
\n\
  Error.Notrace(\"Internal: Cannot find startstate name for funny startstate\");\n\
  return NULL;\n\
}\n\
\n\
/************************************************************/\n\
/* RuleManager */\n\
/************************************************************/\n\
RuleManager::RuleManager() : rules_fired(0)\n\
{\n\
  NumTimesFired = new unsigned long [RULES_IN_WORLD];\n\
  generator = new NextStateGenerator;\n\
\n\
  // initialize check timesfired\n\
  for (int i=0; i<RULES_IN_WORLD; i++)  \n\
    NumTimesFired[i]=0;\n\
};\n\
\n\
RuleManager::~RuleManager()\n\
{\n\
  delete[ OLD_GPP(RULES_IN_WORLD) ] NumTimesFired;\n\
}\n\
\n\
void \n\
RuleManager::ResetRuleNum()\n\
{\n\
  what_rule = 0;\n\
}\n\
\n\
void \n\
RuleManager::SetRuleNum(unsigned r)\n\
{\n\
  what_rule = r;\n\
}\n\
\n\
state * \n\
RuleManager::SeqNextState()\n\
{\n\
  state * ret;\n\
\n\
  what_rule = StateSet->NextRuleToTry();\n\
\n\
  generator->SetNextEnabledRule(what_rule);\n\
\n\
  if ( what_rule<numrules )\n\
    {\n\
      ret = NextState();\n\
      StateSet->NextRuleToTry(what_rule+1);\n\
      return ret;\n\
    }\n\
  else\n\
    return NULL;\n\
}\n\
\n\
// Uli: un-commented, fixed memory leak\n\
state * \n\
RuleManager::RandomNextState()\n\
{ \n\
  unsigned PickARule;\n\
  setofrules rulesleft;\n\
  static state *originalstate = new state;  // buffer, for deadlock checking\n\
  \n\
  // save workingstate\n\
  StateCopy(originalstate, workingstate);\n\
  \n\
  // setup set of rules to be checked\n\
  rulesleft.includeall();\n\
  \n\
  // nondeterministically fire rules until a different state is obtained\n\
  // or no rule available\n\
  category = CONDITION;\n\
  \n\
  while (StateCmp(originalstate,curstate)==0 && rulesleft.size()!=0 )\n\
    {\n\
      PickARule = (unsigned) (random.next() % rulesleft.size());\n\
      what_rule = rulesleft.getnthrule(PickARule);\n\
      if ( generator->Condition(what_rule) )\n\
	{\n\
	  category = RULE;\n\
	  generator->Code(what_rule);\n\
	}\n\
      curstate = workingstate;\n\
    }    \n\
  \n\
  // if deadlock occurs\n\
  if (!args->no_deadlock.value && StateCmp(originalstate,curstate)==0)\n\
    {\n\
      cout << \"\\nStatus:\\n\\n\";\n\
      cout << \"\\t\" << rules_fired << \" rules fired in simulation in \"\n\
	   << SecondsSinceStart() << \"s.\\n\";\n\
      Error.Notrace(\"Deadlocked state found.\");\n\
    }\n\
  \n\
  rules_fired++;\n\
  \n\
  // print verbose message\n\
  if (args->verbose.value & !args->full_trace.value) Reporter->print_fire_rule_diff( originalstate );\n\
  if (args->verbose.value & args->full_trace.value) Reporter->print_fire_rule();\n\
  \n\
  if (!Properties->CheckInvariants())\n\
    {\n\
      cout << \"\\nStatus:\\n\\n\";\n\
      cout << \"\\t\" << rules_fired << \" rules fired in simulation in \"\n\
	   << SecondsSinceStart() << \"s.\\n\";\n\
      Error.Notrace(\"Invariant %s failed.\", Properties->LastInvariantName() );\n\
    }\n\
  \n\
  // progress report\n\
  if ( !args->verbose.value && rules_fired % args->progress_count.value == 0 )\n\
    {\n\
      cout << \"\\t\" << rules_fired << \" rules fired in simulation in \"\n\
	   << SecondsSinceStart() << \"s.\\n\";\n\
      cout.flush();\n\
    }\n\
  return curstate;\n\
}\n\
\n\
bool \n\
RuleManager::AllNextStates() \n\
{\n\
  setofrules * fire;\n\
\n\
  // get set of rules to fire\n\
  fire = EnabledTransition();\n\
  \n\
  // generate the set of next states\n\
  return AllNextStates(fire);\n\
}      \n\
\n\
/****************************************\n\
  Generate set of transitions to be made:\n\
  setofrules transitionset_enabled()\n\
  -- future extension\n\
  -- setofrules transitionset_sleepset_rr(sleepset s)\n\
  -- setofrules transitionset_gode_dl(setofrules rs)\n\
  ****************************************/\n\
setofrules *  \n\
RuleManager::EnabledTransition()\n\
{\n\
  static setofrules ret;\n\
  int p;	// Priority of the current rule\n\
\n\
  ret.removeall();\n\
  \n\
  // record what kind of analysis is currently carried out\n\
  category = CONDITION;\n\
\n\
  // Minimum priority among all rules\n\
  minp = INT_MAX;\n\
  // get enabled\n\
  for ( what_rule=0; what_rule<numrules; what_rule++)\n\
    {\n\
      generator->SetNextEnabledRule(what_rule);\n\
      if ( what_rule<numrules ) {\n\
	ret.add(what_rule);\n\
\n\
        // Compute minimum priority\n\
        if ((p = generator->Priority(what_rule)) < minp)\n\
          minp = p;\n\
      }\n\
    }\n\
  return &ret;\n\
} \n\
\n\
/****************************************\n\
  The BFS verification supporting routines:\n\
  void generate_startstateset()\n\
  bool generate_nextstateset_standard(setofrules fire)\n\
  -- future extension\n\
  -- bool generate_nextstateset_sym() \n\
  -- bool generate_nextstateset_gode_dl() \n\
  -- bool generate_nextstateset_sleepset_rr(setofrules fire, sleepset cursleepset)\n\
  -- bool generate_nextstateset_gode_sleepset_dl(sleepset cursleepset)\n\
  ****************************************/\n\
\n\
// Uli: corrected a memory-leak, improved performance\n\
bool\n\
RuleManager::AllNextStates(setofrules * fire)\n\
{\n\
  // this will unconditionally fire rule in \"fire\"\n\
  // please make sure the conditions are true for the rules in \"fire\"\n\
  // before calling this function.\n\
\n\
  static state * originalstate = new state;   // buffer for workingstate\n\
  state * nextstate;\n\
  bool deadlocked_so_far = TRUE;\n\
  bool permanent;\n\
\n\
  StateCopy(originalstate, workingstate);   // make copy of workingstate\n\
 \n\
  /*\n\
  for ( what_rule=0; what_rule<numrules; what_rule++)\n\
  {\n\
    if (generator->Condition(what_rule) !=\n\
        fire->in(what_rule)) {\n\
      if (!fire->in(what_rule)) {\n\
        cout << \"Condition for rule \" << what_rule << \" is true \";\n\
        cout << \"but it is not in fire!\\n\";\n\
        exit(89);\n\
      }\n\
      else {\n\
        cout << \"Rule \" << what_rule << \" is in fire \";\n\
        cout << \"but its condition is false!\\n\";\n\
        exit(99);\n\
      }\n\
    }\n\
  }\n\
  */\n\
\n\
  for ( what_rule=0; what_rule<numrules; what_rule++)\n\
    {\n\
      if (fire->in(what_rule) && generator->Priority(what_rule)<=minp)\n\
      // if (fire->in(what_rule) )\n\
	{\n\
	  nextstate = NextState();\n\
	  if ( StateCmp(curstate,nextstate)!=0 ) {\n\
            deadlocked_so_far = FALSE;\n\
            permanent = (generator->Priority(what_rule)<50);   // Uli\n\
	    (void) StateSet->Add(nextstate, TRUE, permanent);\n\
	    StateCopy(workingstate, originalstate);   // restore workingstate\n\
          }\n\
	} \n\
    }\n\
  return deadlocked_so_far;\n\
}\n\
\n\
// the following global variables have been set:\n\
// theworld, curstate and what_rule\n\
state * \n\
RuleManager::NextState()\n\
{\n\
  \n\
  category = RULE;\n\
\n\
  // fire rule\n\
  generator->Code(what_rule);\n\
  rules_fired++;\n\
  \n\
  // update timesfired record\n\
  NumTimesFired[what_rule]++;\n\
  \n\
  // print verbose message\n\
  if (args->verbose.value) Reporter->print_fire_rule();\n\
  \n\
  // Uli: invariant check moved\n\
//  if (!Properties->CheckInvariants())\n\
//    {\n\
//      Error.Error(\"Invariant \\\"%s\\\" failed.\",Properties->LastInvariantName());\n\
//    }\n\
  \n\
  // get next state\n\
#ifdef HASHC\n\
  if (args->trace_file.value)\n\
    workingstate->previous.set(NumCurState);\n\
  else\n\
#endif\n\
    workingstate->previous.set(curstate);\n\
  return workingstate;\n\
}\n\
\n\
void \n\
RuleManager::print_world_to_state(StatePtr p, bool fullstate)\n\
{\n\
  state original;\n\
  state nextstate;\n\
  char *s;\n\
\n\
  // save last state\n\
  StateCopy(&original, workingstate);\n\
  \n\
  // generate next state\n\
  for ( what_rule=0; what_rule<numrules; what_rule++)\n\
    {\n\
      category = CONDITION;\n\
      if (generator->Condition(what_rule))\n\
 	{\n\
	  category = RULE;\n\
	  generator->Code(what_rule);\n\
	  StateCopy(&nextstate, workingstate);\n\
\n\
	  if (StateEquivalent(&nextstate, p))\n\
	    {\n\
	      // output the name of the rule and the last state in full\n\
	      cout << \"Rule \"\n\
		   // << rules[ what_rule ].name\n\
		   << (s=generator->Name(what_rule))\n\
		   << \" fired.\\n\";\n\
              delete[] s;   // Uli: avoid memory leak\n\
	      if (fullstate)\n\
		cout << \"The last state of the trace (in full) is:\\n\";\n\
	      if (args->full_trace.value || fullstate) \n\
		theworld.print();\n\
	      else\n\
		theworld.print_diff( &original );\n\
	      cout << \"----------\\n\\n\";\n\
	      return;\n\
	    }\n\
	  else\n\
	      StateCopy(workingstate, &original);\n\
 	}\n\
    }\n\
  Error.Notrace(\"Internal Error:print_world_to_state().\");\n\
}\n\
\n\
char * \n\
RuleManager::LastRuleName()\n\
{\n\
  return generator->Name(what_rule);\n\
}\n\
\n\
unsigned long RuleManager::NumRulesFired()\n\
{\n\
  return rules_fired;\n\
}\n\
\n\
void \n\
RuleManager::print_rules_information()\n\
{\n\
  bool exist = FALSE;\n\
\n\
  if (args->print_rule.value)\n\
    {\n\
      \n\
      cout << \"Rules Information:\\n\\n\";\n\
      for (int i=0; i<RULES_IN_WORLD; i++)  \n\
	cout << \"\\tFired \" << NumTimesFired[i] << \" times\\t- Rule \\\"\"\n\
	     << generator->Name(i)\n\
	     << \"\\\"\\n\";\n\
    }\n\
  else\n\
    {\n\
      for (int i=0; i<RULES_IN_WORLD && !exist; i++)  \n\
	if (NumTimesFired[i]==0)\n\
	  exist = TRUE;\n\
      if (exist)\n\
	cout << \"Analysis of State Space:\\n\\n\"\n\
	     << \"\\tThere are rules that are never fired.\\n\"\n\
	     << \"\\tIf you are running with symmetry, this may be why.  Otherwise,\\n\"\n\
	     << \"\\tplease run this program with \\\"-pr\\\" for the rules information.\\n\";\n\
    }\n\
}\n\
  \n\
/************************************************************/\n\
/* PropertyManager */\n\
/************************************************************/\n\
PropertyManager::PropertyManager()\n\
{\n\
}\n\
\n\
bool \n\
PropertyManager::CheckInvariants()\n\
{\n\
  category = INVARIANT;\n\
  for ( what_invariant = 0; what_invariant < numinvariants; what_invariant++ )\n\
    {\n\
      if ( !( *invariants[ what_invariant ].condition )() )\n\
        /* Uh oh, invariant blown. */\n\
        {\n\
	  return FALSE;\n\
        }\n\
    }\n\
  return TRUE;\n\
}\n\
\n\
char * \n\
PropertyManager::LastInvariantName()\n\
{\n\
  return invariants[what_invariant].name;\n\
}\n\
\n\
/************************************************************/\n\
/* SymmetryManager */\n\
/************************************************************/\n\
SymmetryManager::SymmetryManager()\n\
{\n\
}\n\
\n\
/************************************************************/\n\
/* POManager */\n\
/************************************************************/\n\
POManager::POManager()\n\
{\n\
}\n\
\n\
/************************************************************/\n\
/* AlgorithmManager */\n\
/************************************************************/\n\
AlgorithmManager::AlgorithmManager()\n\
{\n\
  // why exists? (Norris)\n\
  // oldnh = set_new_handler(&err_new_handler);\n\
\n\
  // create managers\n\
  StartState = new StartStateManager;\n\
  Rules = new RuleManager;\n\
  Properties = new PropertyManager;\n\
  Symmetry = new SymmetryManager;\n\
  PO = new POManager;\n\
  Reporter = new ReportManager;\n\
\n\
#ifdef HASHC\n\
  h3 = new hash_function(BLOCKS_IN_WORLD);\n\
#endif\n\
\n\
  Reporter->CheckConsistentVersion();\n\
  if (args->main_alg.mode!=argmain_alg::Nothing)\n\
    Reporter->print_header();\n\
  Reporter->print_algorithm();\n\
\n\
  switch( args->main_alg.mode )\n\
    {\n\
    case argmain_alg::Verify_bfs:\n\
      StateSet = new StateManager(TRUE, NumStatesGivenBytes( args->mem.value ));\n\
      StateSet->print_capacity();\n\
      break;\n\
    case argmain_alg::Verify_dfs:\n\
      StateSet = new StateManager(FALSE, NumStatesGivenBytes( args->mem.value ));\n\
      StateSet->print_capacity();\n\
      break;\n\
    case argmain_alg::Simulate:\n\
      StateSet = NULL;\n\
      break;\n\
    default:\n\
      break;\n\
    }\n\
\n\
  Reporter->print_warning();\n\
\n\
  // signal(SIGFPE, &catch_div_by_zero);\n\
\n\
};\n\
\n\
/****************************************\n\
  The BFS verification main routines:\n\
  void verify_bfs_standard()\n\
  -- future extension:\n\
  -- void verify_bfs_gode_dl()\n\
  -- void verify_bfs_sleepset_rr()\n\
  -- void verify_bfs_gode_sleepset_dl()\n\
  ****************************************/\n\
void \n\
AlgorithmManager::verify_bfs()\n\
{\n\
  // Use Global Variables: what_rule, curstate, theworld, queue, the_states\n\
  setofrules fire;  // set of rule to be fired\n\
   bool deadlocked;  // boolean for checking deadlock\n\
  \n\
  // print verbose message\n\
  if (args->verbose.value) Reporter->print_verbose_header();\n\
\n\
  cout.flush();\n\
  \n\
  theworld.to_state(NULL); // trick : marks variables in world\n\
\n\
  // Generate all start state\n\
  StartState->AllStartStates();\n\
\n\
#ifdef HASHC\n\
  // omission probability calculation\n\
  StateSet->CheckLevel();\n\
#endif\n\
  \n\
  // search state space\n\
  while ( !StateSet->QueueIsEmpty() )\n\
    {\n\
      // get and remove a state from the queue\n\
      // please make sure that global variable curstate does not change \n\
      // throughout the iteration \n\
      curstate = StateSet->QueueDequeue();\n\
      NumCurState++;\n\
      StateCopy(workingstate, curstate);\n\
      \n\
      // print verbose message\n\
      if (args->verbose.value) Reporter->print_curstate();\n\
      \n\
      // generate all next state \n\
      deadlocked = Rules->AllNextStates();\n\
      \n\
      // check deadlock \n\
      if ( deadlocked && !args->no_deadlock.value )\n\
	Error.Deadlocked(\"Deadlocked state found.\");\n\
\n\
#ifdef HASHC\n\
      // omission probability calculation\n\
      StateSet->CheckLevel();\n\
\n\
      delete curstate;\n\
#endif\n\
    } // while\n\
  Reporter->print_final_report();\n\
}\n\
\n\
/****************************************\n\
  The DFS verification routine:\n\
  void verify_dfs()\n\
  -- not changed yet \n\
  ****************************************/\n\
\n\
void \n\
AlgorithmManager::verify_dfs()\n\
{\n\
  // use global variables: what_rule, curstate, theworld, queue, the_states\n\
  state *nextstate;\n\
  bool deadlocked_so_far = TRUE;\n\
  \n\
  // print verbose message\n\
  if (args->verbose.value) Reporter->print_verbose_header();\n\
\n\
  theworld.to_state(NULL); // trick : marks variables in world\n\
\n\
  // for each startstate start a DFS search\n\
  while ((curstate = StartState->NextStartState()) != NULL)\n\
    {\n\
      (void) StateSet->Add(curstate, FALSE, TRUE);\n\
\n\
      while ( !StateSet->QueueIsEmpty() )\n\
 	{\n\
 	  // get the last state from the stack\n\
	  curstate = StateSet->QueueTop();\n\
	  StateCopy(workingstate, curstate);\n\
	    \n\
 	  // l) method:\n\
 	  // get a different next state by incrementing what_rule\n\
 	  // until a rule is enabled and the new state is different from the\n\
 	  // old state or all the rules are exhausted\n\
 	  // 2) setting of varibles\n\
 	  // what_rule is set by previous iteration\n\
 	  // curstate is set at the beginning of the iteration\n\
 	  // theworld is set at the beginning of the iteration\n\
 	  \n\
 	  // get next rule that is enabled and fire it\n\
          // set global variable what_rule\n\
	\n\
 	  nextstate = Rules->SeqNextState();\n\
\n\
 	  if ( nextstate!=NULL )\n\
	    {\n\
	      if ( StateCmp(curstate,nextstate)!=0 )\n\
	      {\n\
	        // curstate state does not deadlock\n\
	        deadlocked_so_far = FALSE;\n\
\n\
	        // check if the next state has been searched or not\n\
	        if (StateSet->Add(nextstate, TRUE, TRUE))\n\
		{\n\
 		  // curstate state does not deadlock, but the next state might\n\
 		  deadlocked_so_far = TRUE;\n\
 		}\n\
 	        else\n\
 		{\n\
 		  // a rule has been fired and the next state has been searched\n\
 		  // ==> check next rule\n\
 		  if (args->verbose.value) \n\
 		    cout << \"This state has been examined, try another rule.\\n\";\n\
 		}\n\
              }\n\
              else\n\
                if (args->verbose.value)\n\
                  cout << \"This state has been examined, try another rule.\\n\";\n\
 	    }\n\
 	  else\n\
 	    {\n\
	      // check deadlock\n\
	      if ( deadlocked_so_far && !args->no_deadlock.value )\n\
		{\n\
		  if (args->verbose.value) Reporter->print_dfs_deadlock();\n\
		  Error.Deadlocked(\"Deadlocked state found.\");\n\
		}\n\
	      \n\
	      // remove explored state\n\
 	      (void) StateSet->QueueDequeue();\n\
\n\
 	      // print verbose message\n\
 	      if (args->verbose.value) Reporter->print_retrack();\n\
 	      \n\
 	      // previous state does not deadlock, as it gives the state just removed\n\
 	      deadlocked_so_far = FALSE;\n\
 	      \n\
#ifdef HASHC\n\
	      delete curstate;\n\
#endif\n\
 	    } // if\n\
 	} // while\n\
 \n\
       // print verbose message\n\
       if (args->verbose.value)\n\
 	cout << \"------------------------------\\n\"\n\
 	     << \"Finished working on one statestate.\\n\"\n\
 	     << \"------------------------------\\n\";\n\
     } // for\n\
  Reporter->print_final_report();\n\
}\n\
\n\
/****************************************\n\
  The simulation main routine:\n\
  void simulate()\n\
  ****************************************/\n\
\n\
// Uli: added required call to theworld.to_state()\n\
void \n\
AlgorithmManager::simulate()\n\
{\n\
  // progress report must be printed out so as to make sense \n\
  // otherwise, if there is no bug, the program just run on for ever\n\
  // without any message.\n\
   \n\
  // print verbose message\n\
  if (args->verbose.value) Reporter->print_verbose_header();\n\
\n\
  Reporter->StartSimulation();\n\
\n\
  theworld.to_state(NULL);   // trick: marks variables in world\n\
\n\
  // GetRandomStartState will choose a Startstate randomly\n\
  curstate = StartState->RandomStartState();\n\
\n\
  // simulate\n\
  while(1)\n\
    {\n\
      // SimulateRandomRule always executes a rule that leads to\n\
      // a different state.\n\
      curstate = Rules->RandomNextState();\n\
    }\n\
}\n\
\n\
MuGlobal::MuGlobal() {\n\
    working = new state;\n\
    world = new world_class;\n\
    nextgen = new NextStateGenerator;\n\
    startgen = new StartStateGenerator;\n\
    error = new Error_handler;\n\
    variables = new MuGlobalVars;\n\
    symmetry = new SymmetryClass;\n\
}\n\
\n\
/********************\n\
  $Log: mu_system.C,v $\n\
  Revision 1.3  1999/01/29 08:28:09  uli\n\
  efficiency improvements for security protocols\n\
\n\
  Revision 1.2  1999/01/29 07:49:11  uli\n\
  bugfixes\n\
\n\
  Revision 1.4  1996/08/07 18:54:33  ip\n\
  last bug fix on NextRule/SetNextEnabledRule has a bug; fixed this turn\n\
\n\
  Revision 1.3  1996/08/07 01:07:55  ip\n\
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
