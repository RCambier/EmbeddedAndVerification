namespace murphi { const char *mu_util_h_str = "\
/* -*- C++ -*-\n\
 * mu_util.h\n\
 * @(#) header for Auxiliary routines for the driver for Murphi verifiers.\n\
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
#include <limits.h>\n\
\n\
// if you change this,\n\
// please make sure that you change a lot of other things\n\
// including array index error checking\n\
#ifndef ALIGN\n\
// Norris: Must be zero\n\
#define UNDEFVAL 0\n\
#define UNDEFVALLONG 0\n\
#else\n\
// Norris: the biggest value storable\n\
#define UNDEFVAL 0xff\n\
#define UNDEFVALLONG INT_MIN\n\
#endif\n\
\n\
/****************************************\n\
  There are 4 groups of declarations:\n\
  1) utility functions (not in any class)\n\
  2) mu__int / mu__boolean\n\
  3) world_class\n\
  4) timer (not in any class)\n\
  5) random number generator\n\
 ****************************************/\n\
\n\
/****************************************\n\
  Utility functions\n\
 ****************************************/\n\
const char* StrStr(const char* super, const char* sub );\n\
void ErrAlloc( void *p );\n\
void err_new_handler(void);\n\
\n\
// Uli: CATCH_DIV has to be defined or undefined depending on compiler\n\
//      and operating system (see Makefile)\n\
#ifndef CATCH_DIV\n\
void catch_div_by_zero(...);   // for most compilers\n\
#else\n\
void catch_div_by_zero(int);   // for CC on elaines\n\
#endif\n\
\n\
bool IsPrime( unsigned long n );\n\
unsigned long NextPrime( unsigned long n );\n\
unsigned long NumStatesGivenBytes( unsigned long bytes );\n\
char *tsprintf (char *fmt, ...);\n\
\n\
\n\
/****************************************\n\
  The base class for a value\n\
 ****************************************/\n\
\n\
// Uli: general comments about the variables:\n\
// - they are local by default\n\
// - they are made global by calling to_state()\n\
\n\
class mu__int /* a base for a value. */\n\
{\n\
  enum { undef_value=UNDEFVAL };   // Uli: nice way to declare constants\n\
\n\
  void operator=(mu__int&);        // Uli: disallow copying, this can catch\n\
                                   //      possible errors in the Murphi\n\
                                   //      compiler\n\
\n\
protected:\n\
\n\
  bool in_world;           // if TRUE global variable, otherwise local\n\
  int lb, ub; 	           // lower bound and upper bound\n\
  int offset, size;        // offset in the state vector, size (both in bits)\n\
#ifndef ALIGN\n\
  position where;          // more info on position in state vector\n\
#else\n\
  int byteOffset;          // offset in state vector in bytes\n\
  unsigned char *valptr;   // points either into state vector (for globals)\n\
                           //   or to data member cvalue\n\
#endif\n\
  bool initialized;        // whether it is initialized in the startstate\n\
                           //   Uli: seems not to be used any more\n\
  unsigned char cvalue;    // contains value of local variable\n\
\n\
public:\n\
  char *name;              // name of the variable\n\
  char longname[BUFFER_SIZE / 4];\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // constructors\n\
\n\
  mu__int(int lb, int ub, int size, char *n, int os )\n\
  :lb(lb), ub(ub), size(size), initialized(FALSE)\n\
  {\n\
    set_self(n, os); \n\
    undefined();\n\
  };\n\
  mu__int(int lb, int ub, int size)\n\
  :lb(lb), ub(ub), size(size), initialized(FALSE)\n\
  {\n\
    set_self(NULL,0); \n\
    undefined();\n\
  };\n\
\n\
  // Uli: - seems not to be used any more\n\
  //      - however, I left it here since it does the correct things\n\
  mu__int(int lb, int ub, int size, int val)\n\
  :lb(lb), ub(ub), size(size)\n\
  {\n\
    set_self(\"Parameter or function result\", 0); \n\
    operator=(val);\n\
  };\n\
\n\
  // Uli: this constructor is called implicitly for function results\n\
  //      by the code generated by the Murphi compiler\n\
  mu__int(const mu__int &src)\n\
  :lb(src.lb), ub(src.ub), size(src.size), in_world(FALSE)\n\
  {\n\
    set_self(\"Function result\", 0);\n\
    value(src.value());   // value() allows returning undefined values\n\
  };\n\
\n\
  // a destructor.\n\
  virtual ~mu__int( void ) { };\n\
\n\
  // routines for constructor use\n\
  void set_self_ar( char *n1, char *n2, int os ) {  // sets the name\n\
    int l1 = strlen(n1), l2 = strlen(n2);           // without using\n\
    strcpy( longname, n1 );                         // tsprintf\n\
    longname[l1] = '[';\n\
    strcpy( longname+l1+1, n2 );\n\
    longname[l1+l2+1] = ']';\n\
    longname[l1+l2+2] = 0;\n\
    set_self( longname, os );\n\
  };\n\
  void set_self_2( char *n1, char *n2, int os ) {  // sets the name\n\
    strcpy( longname, n1 );                        // without using\n\
    strcat( longname, n2 );                        // tsprintf\n\
    set_self( longname, os );\n\
  };\n\
  void set_self( char *n, int os ) {\n\
    name = n; offset = os;\n\
    in_world = FALSE;   // Uli: variables are local by default\n\
#ifdef ALIGN\n\
    byteOffset = offset/8;\n\
    valptr = (unsigned char *)&cvalue;\n\
#else\n\
    where.longoffset = os / 32;\n\
    if (size < 0) {\n\
      where.mask1 = 0;\n\
      where.shift1 = 0;\n\
      where.mask2 = 0;\n\
      where.shift2 = 0;\n\
    }\n\
    else {\n\
      where.shift1 = os % 32;\n\
      where.mask1 = (1<<size)-1;\n\
      where.mask1 <<= where.shift1;\n\
      where.mask2 = 0;\n\
      if ((os+size)/32 != where.longoffset) {\n\
	where.shift2 = 32-where.shift1;\n\
	where.mask2 = (1<<(size-where.shift2))-1;\n\
      }\n\
    }\n\
    where.longoffset *= 4;\n\
#endif\n\
  };\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // data access routines\n\
\n\
  // Uli: - the following three functions should be replaced by undefined(), \n\
  //        etc.\n\
  //      - left them here since they are called by the the code generated \n\
  //        by the Murphi compiler\n\
  inline void clear()   // set value to minimum\n\
  { value(lb); initialized = TRUE; };\n\
  inline void undefine()   // make variable be undefined \n\
  { undefined(); initialized = TRUE; };\n\
  inline void reset()   // make variable be uninitialized\n\
  { undefined(); initialized = FALSE; };\n\
\n\
  // assignment\n\
#ifndef NO_RUN_TIME_CHECKING\n\
  void boundary_error(int val) const;\n\
\n\
  int operator= (int val)\n\
  {\n\
    if ( ( val <= ub ) && ( val >= lb ) )\n\
    {\n\
      value(val);\n\
      initialized = TRUE;\n\
    }\n\
    else\n\
      boundary_error(val);\n\
    return val;\n\
  }\n\
#else\n\
  int operator= (int val)\n\
  { return value(val); }\n\
#endif\n\
\n\
  // conversion to int\n\
#ifndef NO_RUN_TIME_CHECKING\n\
  int undef_error() const;\n\
\n\
  inline operator int() const\n\
    {\n\
      if (isundefined()) return undef_error();\n\
      return value();\n\
    };\n\
#else\n\
  inline operator int() const { return value(); };\n\
#endif\n\
\n\
  // new data access routines\n\
  // Uli: - the number of functions defined here could be reduced\n\
  //      - new names would be good as well \n\
  //        (\"undefine\" instead of \"undefined\", etc.)\n\
#ifdef ALIGN\n\
  inline const int value() const { return *valptr; };\n\
  inline int value(int val) { *valptr = val; return val; };\n\
  inline void defined(bool val) { if (!val) *valptr = undef_value; };\n\
  inline bool defined() const { return (*valptr != undef_value); };\n\
  inline void undefined() { *valptr = undef_value; };\n\
  inline bool isundefined() const { return (*valptr == undef_value); };\n\
#else\n\
  inline const int value() const {\n\
    if (in_world)\n\
      return workingstate->get(&where)+lb-1;\n\
    else\n\
      return cvalue+lb-1;\n\
  };\n\
  inline int value(int val) {\n\
    if (in_world)\n\
      workingstate->set(&where, val - lb + 1); \n\
    else\n\
      cvalue = val - lb +1;\n\
    return val;\n\
  };\n\
  inline void defined(bool val) {\n\
    if (!val)\n\
      if (in_world)\n\
	workingstate->set(&where,undef_value);\n\
      else\n\
        cvalue = undef_value;\n\
  };\n\
  inline bool defined() const {\n\
    if (in_world)\n\
      return (workingstate->get(&where) != undef_value);\n\
    else\n\
      return cvalue != undef_value;\n\
  };\n\
  inline void undefined() { \n\
    defined(FALSE); \n\
  };\n\
  inline bool isundefined() const { \n\
    if (in_world)\n\
      return (workingstate->get(&where) == undef_value);\n\
    else\n\
      return cvalue == undef_value;\n\
  };\n\
#endif\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // printing, etc.\n\
\n\
  // printing routines\n\
  virtual void print()\n\
  {\n\
    if (defined()) cout << name << \":\" << value() << '\\n';\n\
    else cout << name << \":Undefined\\n\" ;\n\
  };\n\
  friend ostream& operator<< (ostream& s, mu__int& val)\n\
  {\n\
    if (val.defined()) s << val.value();\n\
    else s << \"Undefined\";\n\
    return s;   // changed by Uli\n\
  }\n\
  void print_diff(state *prevstate);\n\
\n\
  // transfer routines\n\
  void to_state(state *thestate) {\n\
    int val = value();   // Uli: copy value (which is probably undefined)\n\
    in_world = TRUE;\n\
#ifdef ALIGN\n\
    valptr = (unsigned char *)&(workingstate->bits[byteOffset]);\n\
#endif\n\
    value(val);\n\
  }; \n\
  void from_state(state *thestate) { };\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // comparing routines, for symmetry\n\
\n\
  friend int CompareWeight(mu__int& a, mu__int& b)\n\
  {\n\
    if (!a.defined() && !b.defined())\n\
      return 0;\n\
    else if (!a.defined())\n\
      return -1;\n\
    else if (!b.defined())\n\
      return 1;\n\
    else if (a.value()==b.value()) return 0;\n\
    else if (a.value()>b.value()) return 1;\n\
    else return -1;\n\
  };\n\
\n\
  friend int Compare(mu__int& a, mu__int& b)\n\
  {\n\
    if (!a.defined() && !b.defined())\n\
      return 0;\n\
    else if (!a.defined())\n\
      return -1;\n\
    else if (!b.defined())\n\
      return 1;\n\
    else if (a.value()==b.value()) return 0;\n\
    else if (a.value()>b.value()) return 1;\n\
    else return -1;\n\
  };\n\
\n\
  virtual void MultisetSort() {};\n\
\n\
};\n\
\n\
\n\
\n\
/****************************************\n\
  The class for a short int (byte)\n\
 ****************************************/\n\
\n\
class mu__byte: public mu__int\n\
{\n\
public:\n\
  // constructors\n\
  mu__byte(int lb, int ub, int size, char *n, int os )\n\
  : mu__int(lb,ub,size,n,os) {};\n\
  mu__byte(int lb, int ub, int size)\n\
  : mu__int(lb,ub,size) {};\n\
  mu__byte(int lb, int ub, int size, int val)\n\
  : mu__int(lb,ub,size,val) {};\n\
\n\
  // assignment\n\
  int operator= (int val)\n\
  { return mu__int::operator=(val); }\n\
\n\
};\n\
\n\
/****************************************\n\
  The class for a long int\n\
 ****************************************/\n\
\n\
// Uli: - this class redefines most almost all functions to access the\n\
//        data\n\
//      - this is necessary because of the different layout of the data\n\
//      - templates may provide a more elegant solution\n\
//        however: pointer-access to the values in the state vector is \n\
//                 not possible since they are not individually aligned\n\
\n\
class mu__long: public mu__int\n\
{\n\
  enum { undef_value=UNDEFVALLONG };\n\
\n\
public:\n\
  int cvalue;   // Uli: hides the cvalue from the base class mu__int\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // constructors\n\
\n\
  // Uli: example problem with the constructors:\n\
  // - the undefined() in the mu__int constructor does not set the mu__long \n\
  //    cvalue\n\
  // - the programming is not too nice, improving, however, seems to require\n\
  //    lots of changes in the code\n\
 \n\
  mu__long(int lb, int ub, int size, char *n, int os )\n\
  :mu__int(lb,ub,size,n,os)\n\
  {\n\
    undefined();\n\
  };\n\
  mu__long(int lb, int ub, int size)\n\
  :mu__int(lb,ub,size) \n\
  { \n\
    undefined();\n\
  };\n\
  mu__long(int lb, int ub, int size, int val)\n\
  :mu__int(lb,ub,size,val) \n\
  { \n\
    operator=(val); \n\
  };\n\
  mu__long(const mu__long &src)\n\
  :mu__int(src)\n\
  {\n\
      value(src.value());\n\
  };\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // data access routines\n\
\n\
  inline void clear() { value(lb); initialized = TRUE; };\n\
  inline void undefine() { undefined(); initialized = TRUE; };\n\
  inline void reset() { undefined(); initialized = FALSE; };\n\
\n\
  // assignment\n\
#ifndef NO_RUN_TIME_CHECKING\n\
  int operator= (int val)\n\
  {\n\
    if ( ( val <= ub ) && ( val >= lb ) )\n\
    {\n\
      value(val);\n\
      initialized = TRUE;\n\
    }\n\
    else\n\
      boundary_error(val);\n\
    return val;\n\
  }\n\
#else\n\
  int operator= (int val)\n\
  { return value(val); }\n\
#endif\n\
\n\
  // conversion to int\n\
#ifndef NO_RUN_TIME_CHECKING\n\
  inline operator int() const\n\
    {\n\
      if (isundefined()) return undef_error();\n\
      return value();\n\
    };\n\
#else\n\
  inline operator int() const { return value(); };\n\
#endif\n\
\n\
  // new data access routines\n\
#ifdef ALIGN\n\
  inline const int value() const { \n\
    if (in_world)\n\
      return workingstate->getlong(byteOffset);\n\
    else\n\
      return cvalue;\n\
  }; \n\
  inline int value(int val) {\n\
    if (in_world)\n\
      workingstate->setlong(byteOffset, val);\n\
    else\n\
      cvalue = val;\n\
    return val;\n\
  };\n\
  inline void undefined() {\n\
    if (!in_world)\n\
      cvalue = undef_value;\n\
    else\n\
      workingstate->setlong(byteOffset,undef_value);\n\
  };\n\
  inline void defined(bool val) {\n\
    if (!val)\n\
      if (!in_world)\n\
	cvalue = undef_value;\n\
      else\n\
	workingstate->setlong(byteOffset,undef_value); \n\
  };\n\
  bool defined() const {\n\
    if (in_world)\n\
      return (workingstate->getlong(byteOffset) != undef_value);\n\
    else\n\
      return cvalue != undef_value;\n\
  };\n\
  bool isundefined() const {\n\
    if (in_world)\n\
      return (workingstate->getlong(byteOffset) == undef_value);\n\
    else\n\
      return cvalue == undef_value;\n\
  };\n\
#else\n\
  // Uli: - code from mu__int has to be duplicated here\n\
  //      - otherwise the wrong cvalue/undef_value is accessed\n\
  inline const int value() const {\n\
    if (in_world)\n\
      return workingstate->get(&where)+lb-1;\n\
    else\n\
      return cvalue+lb-1;\n\
  };\n\
  inline int value(int val) {\n\
    if (in_world)\n\
      workingstate->set(&where, val - lb + 1);\n\
    else \n\
      cvalue = val - lb +1;\n\
    return val;\n\
  };\n\
  inline void defined(bool val) {\n\
    if (!val)\n\
      if (in_world)\n\
        workingstate->set(&where,undef_value);\n\
      else\n\
        cvalue = undef_value;\n\
  };\n\
  inline bool defined() const {\n\
    if (in_world)\n\
      return (workingstate->get(&where) != undef_value);\n\
    else\n\
      return cvalue != undef_value;\n\
  };\n\
  inline void undefined() { \n\
    defined(FALSE); \n\
  };\n\
  inline bool isundefined() const {\n\
    if (in_world)\n\
      return (workingstate->get(&where) == undef_value);\n\
    else\n\
      return cvalue == undef_value;\n\
  };\n\
#endif\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // printing, etc.\n\
\n\
  // printing routine, added by Uli\n\
  virtual void print()\n\
  {\n\
    if (defined()) cout << name << \":\" << value() << '\\n';\n\
    else cout << name << \":Undefined\\n\";\n\
  }\n\
  friend ostream& operator<< (ostream& s, mu__long& val)\n\
  {\n\
    if (val.defined()) s << (int)val;\n\
    else s << \"Undefined\" ;\n\
    return s;\n\
  }\n\
  void print_diff(state *prev);\n\
\n\
  // transfer routines\n\
  void to_state(state *thestate) {\n\
    int val = value();   // Uli: copy value (which is probably undefined)\n\
    in_world = TRUE;\n\
    value(val);\n\
  };\n\
\n\
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n\
  // comparing routines, for symmetry\n\
\n\
  friend int CompareWeight(mu__long& a, mu__long& b)\n\
    {\n\
      if (!a.defined() && !b.defined())\n\
	return 0;\n\
      else if (!a.defined())\n\
	return -1;\n\
      else if (!b.defined())\n\
	return 1;\n\
      else if (a.value()==b.value()) return 0;\n\
      else if (a.value()>b.value()) return 1;\n\
      else return -1;\n\
    };\n\
  \n\
  friend int Compare(mu__long& a, mu__long& b)\n\
    {\n\
      if (!a.defined() && !b.defined())\n\
	return 0;\n\
      else if (!a.defined())\n\
	return -1;\n\
      else if (!b.defined())\n\
	return 1;\n\
      else if (a.value()==b.value()) return 0;\n\
      else if (a.value()>b.value()) return 1;\n\
      else return -1;\n\
    };\n\
};\n\
\n\
\n\
/****************************************\n\
  The class for a boolean\n\
 ****************************************/\n\
\n\
class mu_0_boolean: public mu__int\n\
/* In the Murphi compilation, we typecheck against mixing ints and enums,\n\
 * so now, we can allow it to be mixed with integers without catastrophe. */\n\
{\n\
  // extra data from mu__int\n\
  static char * values[];\n\
  \n\
  // special stream operation --> use names false or true\n\
  friend ostream& operator<<(ostream& s, mu_0_boolean& x)\n\
  { \n\
    if (x.defined()) return s << mu_0_boolean::values[int(x)];\n\
    else return s << \"Undefined\" ; \n\
  }\n\
  \n\
public:\n\
#ifndef NO_RUN_TIME_CHECKING\n\
  inline int operator=(int val) {\n\
    initialized = TRUE; return value(val ? 1 : 0); };\n\
  inline int operator= (const mu_0_boolean& val ) {\n\
    initialized = TRUE; return value(val ? 1 : 0); };\n\
#else\n\
  inline int operator=(int val) { return value(val); };\n\
  inline int operator= (const mu_0_boolean& val ) { return value(val); };\n\
#endif\n\
  \n\
  mu_0_boolean (char *name, int os) \n\
  : mu__int(0,1,2, name, os) {};\n\
  mu_0_boolean ( void) \n\
  : mu__int(0,1,2) {};\n\
  mu_0_boolean (int val ) \n\
  : mu__int(0,1,2, \"Parameter or function result\", 0)\n\
  { operator=(val); };\n\
\n\
  // special assignment for boolean\n\
  char * Name() { return values[value()]; };\n\
\n\
  // canonicalization function for symmetry\n\
  virtual void Permute(PermSet& Perm, int i);\n\
  virtual void SimpleCanonicalize(PermSet& Perm);\n\
  virtual void Canonicalize(PermSet& Perm);\n\
  virtual void SimpleLimit(PermSet& Perm);\n\
  virtual void ArrayLimit(PermSet& Perm);\n\
  virtual void Limit(PermSet& Perm);\n\
\n\
  // special print for boolean --> use name False or True\n\
  virtual void print() { \n\
    if (defined()) cout << name << \":\" << values[value()] << '\\n'; \n\
    else cout << name << \":Undefined\\n\";\n\
  };\n\
  void print_statistic() {};\n\
};\n\
\n\
/****************************************\n\
  world_class declarations\n\
 ****************************************/\n\
\n\
class world_class\n\
{\n\
public:\n\
  void print(); /* print out the values of all variables. */\n\
  void print_statistic(); \n\
  void print_diff( state *prevstate );\n\
  void clear(); /* clear every variable. */\n\
  void undefine(); /* undefine every variable. */\n\
  void reset(); /* uninitialize every variable. */\n\
  /*\n\
   * this is something of a different approach than previous versions--\n\
   * we let the translation of the world\n\
   * into states be a property of the world,\n\
   * instead of a property of the state.\n\
   */\n\
  void to_state(state *newstate); /* encode the world into newstate. */\n\
  state *getstate(); /* return a state encoding the values of all variables. */\n\
  state_L *getstate_L(); /* return a state_L */\n\
  void setstate( state *thestate ); /*set the state of the world to\n\
				    /*thestate.*/\n\
};\n\
\n\
/***************************\n\
  Timer\n\
 ***************************/\n\
double SecondsSinceStart( void );\n\
\n\
\n\
/***************************   // added by Uli\n\
  random number generator\n\
 ***************************/\n\
class randomGen\n\
// random number generator\n\
{\n\
  private:\n\
    unsigned long value;\n\
  public:\n\
    randomGen();\n\
    unsigned long next();   // return next random number\n\
};\n\
\n\
\n\
/****************************************\n\
  1) 20 Dec 93 Norris Ip: \n\
  added the following to mu_0_boolean:\n\
        void mu_0_boolean::Permute(PermSet& Perm, int i) {};\n\
        void mu_0_boolean::Canonicalize(PermSet& Perm) {};\n\
        void mu_0_boolean::Limit(PermSet& Perm) {};\n\
  2) 28 Feb 94 Norris Ip:\n\
  added the following to mu_0_boolean:\n\
        void mu_0_boolean::SimpleCanonicalize(PermSet& Perm) {};\n\
  3) 28 Feb 94 Norris Ip:\n\
  fixed checking whether variable is initialized.\n\
  4) 8 March 94 Norris Ip:\n\
  merge with the latest rel2.6\n\
****************************************/\n\
\n\
/********************\n\
  $Log: mu_util.h,v $\n\
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
