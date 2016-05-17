Romeo v2.10.0 + Mercutio v2.10.0 "Mercuzion"
Copyright (c) All rights reserved / IRCCyN

Institut de Recherche en Communication et Cybernetique de Nantes
Equipe Systemes Temps-Reel
UMR CNRS 6597
1 rue de la Noe - BP92101
44321 Nantes Cedex 3 
FRANCE

Website: http://romeo.rts-software.org
Contact: romeo@irccyn.ec-nantes.fr

INDEX
-----
    1 - DESCRIPTION
    2 - REQUIREMENTS
    3 - INSTALLATION
    4 - RUN ROMEO
    5 - COMPILING

1 - DESCRIPTION
---------------
Romeo is a modeling and verification tool for T-time Petri Nets (TPNs), Petri 
nets extended with stopwatches (SwPNs) and parametric TPNs or parametric SwPNs. 
It consists of:
    * a graphical interface to edit and simulate Petri nets,
    * Mercutio, a set of tools performing:
        - the computation of the marking graph and the marking time automaton;
        - the computation of the state space of the net as a state-class graph, 
            a state-class automaton or a zone-based graph;
        - the structural translation of the TPN into a timed automaton;
        - TPN-TCTL model-checking on bounded TPNs: the TCTL properties belong 
            to a subset of TCTL where atomic propositions are expressed using 
            GMECs (General Mutual Exclusion Constraints);
        - PTPN-PTCTL parametric model-checking for parametric TPNs and 
            parametric SwPNs;
        - unfolding of safe TPNs and PTPNs, and supervision of partial 
            observations.

2 - REQUIREMENTS (Win32)
------------------------
Tcl/Tk  8.4.19 (WARNING: Do NOT install a higher version if using the GUI!)
    (http://www.activestate.com/activetcl)

3 - INSTALLATION
----------------
Binaries distribution are available for MacOSX, Linux and Win32.

    * Windows:
        Unzip the <romeo-xxx-windows.zip> file or execute the 
        <romeo-xxx-windows.exe> self-extracting archive.
    * Linux:
        Untar the <romeo-xxx-linux.tar.gz> romeo archive
    * MacOSX:
        Mount the <romeo-xxx.dmg> image disk
        Drag and drop the <Romeo> application to your Applications directory.

4 - RUN ROMEO
-------------
    * Windows:
        double-click the <romeo.tcl> script in the 'gui' directory (or on the 
        desktop if a shortcut icon has been created during the installation) or 
        select the <Launch Romeo> menu in the 'Start/Programs/Romeo' menu. 
    * Linux:
        run the <romeo> program: $./romeo
    * MacOsX:
        double-click the <Romeo> application. 

Use the menu item 'Edit/Preferences' to set your configuration.

You can also run <mercutio>, <mercutio-tctl> and <mercutio-unf> in a shell. 
See their respective documentation. 

5 - COMPILING (Win32)
---------------------
To build the different programs from the source code, you need, under Win32:
    * the MinGW Compiler Suite (including both the C and the C++ compiler), 
        the MSYS Basic System and the MinGW Developer ToolKit
        (http://www.sourceforge.net/projects/mingw/files/Installer/mingw-get-inst)
        The extended version of MinGW/MSYS should allow you to have the 
        following programs:
            >> awk (3.1.7)
            >> ar (2.22)
            >> gcc "core" and g++ (4.6.2)
            >> autoconf (2.68)
            >> automake (1.11.1)
            >> libtool (2.4)
            >> flex (2.5.35)
            >> bison (2.4.2)
    * Expat XML parser (2.0.1) (libraries and headers); do NOT use the 
        <expat_win32> precompiled version, but re-compile the source code as 
        follows:
            $ LDFLAGS=--static ./configure --prefix=/local && make && make install
        (http://www.sourceforge.net/projects/expat/files/expat)
    * Tcl/Tk (8.4.19, see above)
    * Swig (2.0.4); use the <swigwin> precompiled version and place it 
        preferably at the root of your system
        (http://www.sourceforge.net/projects/swig/files/swigwin)
    * The GNU Multiple Precision Arithmetic Library (5.0.2) 
        (ftp://ftp.gmplib.org/pub/gmp-5.0.2)
        GMP should be configured and installed as follows:
            $ LDFLAGS=--static ./configure --prefix=/local --enable-cxx --with-pic --enable-shared=no
            $ make && make install
    * The Parma Polyhedra Library (0.11.2)
        (http://www.bugseng.com/products/ppl)
        PPL should be configured and installed as follows (ignore the 
        <conftest> errors):
            $ LDFLAGS=--static ./configure --prefix=/local --enable-optimization=speed --enable-coefficients=checked-int64 --enable-shared=no --enable-watchdog=no
            $ make && make install
    * The Boost headers and libraries (1.48.0)
        (http://www.sourceforge.net/projects/boost/files/boost)
        DO NOT use the precompiled version of <bjam.exe> but proceed as follows: 
            >> make sure that your Windows path contains the folder where <gcc> 
                is installed (typically 'C:\MinGW\bin')
            >> modify line 15 of the <bootstrap.bat> file as follows: 
                call .\build.bat gcc %* > ..\..\..\..\bootstrap.log
            >> launch the <bootstrap.bat> file by double-clicking it
            >> you now have a correct version of <bjam.exe> and can revert to 
                the previous Windows path
            >> open an MSYS/MinGW terminal, go to the folder containing 
                <bjam.exe> and configure the Boost headers as follows:
                $ bjam --toolset=gcc --without-mpi --without-python install
            >> move the 'C:\Boost\include\boost-1_48\boost' folder to 
                'C:\MinGW\include' and the 'C:\Boost\lib' folder to 'C:\MinGW' 
                (adapt the paths to your own installation if necessary)
    * Uppaal DBM (2.0.8), a library manipulating Difference Bound Matrices
        (http://www.cs.aau.dk/~adavid/UDBM/)
        UDBM should be configured as follows (go to the 'modules' directory):
            $ CFLAGS='-Wall -O2 -DNDEBUG' LDFLAGS=--static ./configure --prefix=/local
        Sometimes, the <configure> executable does not work properly; you 
        should therefore check that the <Makefile> in 'modules' has the 
        following line:
            export AR := ar
        You can then compile and install the library:
            $ make && make install
    
In order to build and install the Romeo executable and libraries:
    * replace the existing <Makefile> files (in 'romeo', 'romeo/mercution' and 
        'romeo/mercution/source') by the content of the <Makefile.windows> files
    * in the 'romeo/mercution/source' directory, check that the following 
        variables in the <Makefile> are correctly set (paths can either be in 
        the Unix or Windows format):
            BISON_PKGDATADIR
            SWIG
            LOCALLIBS
            INCLUDE_DIR
            EXPAT_LIB, TCL_LIB, PPL_LIB, UDBM_LIB
    * go to the 'romeo' directory and enter the following shell command: 
        $ make depend && make all && make install