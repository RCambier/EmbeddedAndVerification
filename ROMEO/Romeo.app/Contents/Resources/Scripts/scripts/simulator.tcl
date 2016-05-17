# Simulation du reseau de Petri TPN
#*********
#*
#procedure simulateProperty + Control Pannel
#*
#*********

# charge la bibliothèque partagée mercutio pour les calculs
global plateforme
global method

set methode 1
set simulator(mercutio) 0
set simulator(gpn) 0
set simulator(load) 0

proc firstLoad {} {
    global simulator
    global plateforme

    set simulator(load) 1  

    if {[string compare $plateforme "windows"]} {
	affiche "\n"
	affiche [format [mc "-Loading %s ..."] "mercutio.so"]
	if {[catch {load [file join ./lib/mercutio.so]} ep]} {
	    affiche [format [mc "Unable to load %s : %s"] "mercutio.so" $ep]
	} else {
	    affiche [mc "done"]
	    set simulator(mercutio) 1
	    set simulator(gpn) 1
	}
#	affiche "\n"
#	affiche   [format [mc "-Loading %s ..."] "gpn.so"]
#	if {[catch {load [file join ./lib/gpn.so]} ep]} {
#	    affiche [format [mc "Unable to load %s : %s"] "gpn.so" $ep]
#	} else {
#	    affiche [mc "done"]
#	}  
    } else {
	affiche "\n"
	affiche [format [mc "-Loading %s ..."] "mercutio.dll"]
	if {[catch {load [file join ./lib/mercutio.dll]} ep]} {
	    affiche [format [mc "Unable to load %s : %s"] "mercutio.dll" $ep]
	} else {
	    affiche [mc "done"]
        set simulator(mercutio) 1
	    set simulator(gpn) 1
	}
#	affiche "\n"
#	affiche   [format [mc "-Loading %s ..."] "gpn.dll"]
#	if {[catch {load [file join ./lib/gpn.dll]} ep]} {
#	    affiche [format [mc "Unable to load %s : %s"] "gpn.dll" $ep]
#	} else {
#	    affiche [mc "done"]
#	}  
    }
}

proc afficheSimu {texte} {
    
    .fenetreSimul.dialogue.retour.text insert end  "$texte"
    .fenetreSimul.dialogue.retour.text yview moveto 1
}


proc simulateTPN {w c} {
    global nomRdP cheminTemp
    global francais
    global infini
    global scheduling parameters allowedArc outFormat typePN computOption
    global simulatorOn simulator
    global tabPlace tabJeton ok fin tpn
    global cTPN
    global cSState
    global cTPN_EnabledTransList
    global cTPN_FirableTransList
    global modif methode

   if {$typePN!=2} {

    set onSimule 1
    if {!$simulator(load)} {firstLoad}
#    if {($simulator(gpn))&&($scheduling)} { 
#	if {[catch {gpns_initPolka} ep]} { 
#	    affiche "\n " 
#	    affiche [format [mc ">error : %s"] $ep]
#	    set onSimule 0 
#	}
#    }  
    

    set etat(gpn) normal
    set etat(mercutio) normal
    if {($simulator(gpn)+$simulator(mercutio))==1} {
	if {$simulator(gpn)==1} { 
	    set etat(mercutio) disabled
	    set methode 2
	} else { 
	    set etat(gpn) disabled
	    set methode 1
	    if {($parameters>=1)||($scheduling==1)||($scheduling==-1)} {set onSimule 0}
	}
    } elseif {($simulator(gpn)+$simulator(mercutio))==0} {set onSimule 0}

    if {$onSimule} { 
	if {($modif($tpn) ==1)||(![string compare "$nomRdP($tpn)" "noName.xml"])} {
	    set reponse [tk_messageBox -message [mc "Save net?"] -type yesno -icon question]
	    switch -exact $reponse {
		yes { 
		    aiguillageEnregistrer .romeo.global
		    if [string compare "$nomRdP($tpn)" "noName.xml"] {
  		        set nomSimul $nomRdP($tpn) 
		    } else {
		        affiche "\n"
		        affiche [mc "-Petri net not saved. Simulator will run with temporary file TPNSimul.xml"]
		        set nomSimul "$cheminTemp/TPNSimul.xml"
		        enregistrerTpnXml "$nomSimul"
		        set modif($tpn) 1
		    }               

		}
		no {
		    affiche "\n"
		    affiche [mc "-Petri net not saved. Simulator will run with temporary file TPNSimul.xml"]
		    set nomSimul "$cheminTemp/TPNSimul.xml"
		    enregistrerTpnXml "$nomSimul"
		    set modif($tpn) 1
		}
	    }
	} else {set nomSimul $nomRdP($tpn) }

	# ++++++++++++++++ Creation de la fenetre d'affichage ++++++++++++++++++
	
	affiche "\n"
	affiche [mc "-Opening \"Simulator\" window ... Starting simulator"]
	set fp .fenetreSimul
	toplevel $fp -menu .romeo_menu

	wm protocol $fp WM_DELETE_WINDOW {"quitterSimulBrutalement"}
	wm title $fp [mc "TPN simulator"]
	set x [expr [winfo rootx $c] + [winfo width $c]-10]
	if {$x > ([winfo screenwidth $w]*3/4) } { set x [expr int([winfo screenwidth $w]*3/4)] }
	set y [expr [winfo rooty $w] +1 ]
	wm geometry $fp +$x+$y

	frame $fp.dialogue
	pack $fp.dialogue -side left -fill both -expand yes
	
	# message vers l'utilisateur
	frame $fp.dialogue.retour
	set f1 $fp.dialogue.retour
	pack $f1 -side top -fill both -expand yes
	
	if {($parameters>=1)||($scheduling==1)||($scheduling==-1)} {
	    set methode 2
	    set etat(gpn) disabled
	    set etat(mercutio) disabled
	} 

	frame $f1.method 
	pack $f1.method -expand yes
	radiobutton $f1.method.zone -text [mc "Zone-based method"] -variable methode -value 1 -selectcolor red -command "resetSimul $c {$nomSimul}" -state $etat(mercutio)
	radiobutton $f1.method.class -text [mc "State-class method"] -variable methode -value 2 -selectcolor red -command "resetSimul $c {$nomSimul}" -state $etat(gpn)
	pack $f1.method.zone -side top -pady 2 -anchor w
	pack $f1.method.class -side top -pady 2 -anchor w

	text $f1.text -yscrollcommand "$f1.vscroll set" -width 30 -height 50 -bg white -wrap word
	scrollbar $f1.vscroll -command "$f1.text yview"
	pack $f1.text -side left -fill both -expand yes
	pack $f1.vscroll -side right -fill y
	
	# affichage des indices des Transition
	frame $fp.indice -width 20 -height 10
	pack $fp.indice -side right -fill y
	afficheSimuIndice  $fp.indice
	
	frame $fp.dialogue.buttons -bd 2
	button $fp.dialogue.buttons.reset -text [mc "Reset simulation"] -command  "resetSimul $c {$nomSimul}"
	button $fp.dialogue.buttons.quit -text [mc "Quit Simulator"] \
	    -command "editTPN $w $c"
	pack $fp.dialogue.buttons -side bottom -fill both
	pack $fp.dialogue.buttons.reset $fp.dialogue.buttons.quit  -side left -expand 1

	boutonSimTPN $w $c
	if {[catch {initSimulation "$nomSimul"} ep]} {
	    affiche [format [mc "Unable to load %s : %s"] "Petri net" $ep]
	    destroy .fenetreSimul
	} else {
	    set simulatorOn 1
	    redessinerRdP $c
	    if {$scheduling==1} {
			afficheSimu [mc "Scheduling mode selected\n"]
			affiche "\n"
	    } 
            if {$parameters>=1} {
			afficheSimu [mc "Parametric mode selected\n"]
			affiche "\n "
	    }
	    afficheSimu [mc "Color semantics:"]
	    afficheSimu "\n "
	    afficheSimu [mc "-Enabled transitions -> brown; "]
	    afficheSimu "\n "
	    afficheSimu [mc "-Firable transitions -> green"]
	    afficheSimu "\n "
	    afficheSimu [mc "Click on the transition to fire"]
	    afficheSimu "\n "
		afficheSimu "-----------------------\n"
	    if {$methode==1} {
			afficheSimu [mc "Initial zone:"]
	    } else {
			afficheSimu [mc "Initial class:"]
	    }
		afficheSimu "\n"
		afficheSimu [printDomain $cSState]

	    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
			if {$tabPlace($tpn,$i,statut)==$ok} {
			    set tabJeton($i)  $tabPlace($tpn,$i,jeton) 
			}
	    }
	} 
    } else { affiche " \n "
        affiche [mc "This simulator library has not been loaded"]
	}
  } else {
      affiche "\n"
      affiche "-Simulation not available for P-TPN"
  }
}

#++++++ procedures internes à simulate property


proc afficheSimuIndice {fi} {
    global tabTransition tpn
    global fin
    global ok
    global infini

    text $fi.text -yscrollcommand "$fi.vscroll set" -setgrid true \
	-width 20 -height 8 
    scrollbar $fi.vscroll -command "$fi.text yview"
    # -xscrollcommand "$fi.hscroll set"
    # scrollbar $fi.hscroll -orient horiz -command "$fi.text xview"


    pack $fi.vscroll -side right -fill y
    pack $fi.text -expand yes -fill both
    # pack $fi.hscroll -side bottom -fill x

    $fi.text tag configure rouge -foreground red
    $fi.text tag configure surgris -background #a0b7ce
    $fi.text tag configure souligne -underline on


    $fi.text insert end "  TRANSITION    \n" souligne
    $fi.text insert end "Indice " surgris
    $fi.text insert end "  \"label\" \n" rouge


    # transition par transition
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabTransition($tpn,$i,statut)==$ok} {
	    $fi.text insert end "$i     " surgris
	    $fi.text insert end "  \"$tabTransition($tpn,$i,label,nom)\"\n" rouge
	}
    }
}
#++++++++++++++++++
proc simulatorFireTranstion {c i} {
    global tabTransition tpn
    global tabPlace tabJeton 
    global ok fin
    global cTPN
    global cSState
    global cTPN_EnabledTransList
    global cTPN_FirableTransList
    global methode scheduling parameters typePN
    
    if {[firable $i]} {
		afficheSimu [format [mc "Firing %s"] $tabTransition($tpn,$i,label,nom)]
		afficheSimu "\n"
		#mise à jour du réseau version C
		afficheSimu "-----------------------\n"
		if {$methode==1} {
		    afficheSimu [mc "Zone:"]
		} else {
		    afficheSimu [mc "Class:"]
		} 
		afficheSimu "\n"
		set cSState [fireTransition $cTPN $i $cSState]
		set cTPN_EnabledTransList [getEnabledTransitions $cTPN]
		set cTPN_FirableTransList [getFirableTransitions $cSState] 
		#modification du marquage
		afficheSimu [printDomain $cSState]
		for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
			if {$tabPlace($tpn,$i,statut)==$ok} {
				set tabPlace($tpn,$i,jeton) [getMarking $cTPN $i]
			}
		} 
		redessinerRdP $c
    } else {
		afficheSimu [format [mc ">Warning: Transition %s is not firable"] $tabTransition($tpn,$i,label,nom)]
		afficheSimu "\n"
    }
}  


#--------------- INIT RESET QUIT.... simulator


#---------------- Initialisation de la simulation 

proc initSimulation {nomFichier} {
    # variables globales pour le calcul
    global cTPN
    global cSState
    global cTPN_EnabledTransList
    global cTPN_FirableTransList
    global methode parameters typePN computOption

#typePN : -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn
#parameters: 1 real 2 integer
    if {$parameters>=1} {
	# charge le réseau de Petri
	if {$typePN==-2} {
	    set cTPN [pssc_loadTPN $nomFichier]
	} elseif  {$typePN==-1} {
	    set cTPN [pwsc_loadTPN $nomFichier]
	} else {
	    set cTPN [p_loadTPN $nomFichier]
	}

	# Initialiser le calcul parametres entiers ou non

# rappel computOption(hull) = 1 si enveloppe sur projection sur param OU 2 si enveloppe sur tout
	if {$parameters==2} {
	   set retourVoid  [p_setIntegralParams $cTPN $computOption(hull)]
	} 

	# créer la zone initiale
	set cSState [pssc_initial_zone $cTPN]

# si pas de parametre :
    } elseif {$typePN==-2} {
	# charge le réseau de Petri
	set cTPN [ssc_loadTPN $nomFichier]
	# créer la zone initiale
	set cSState [ssc_initial_zone $cTPN]

    } elseif  {$typePN==-1} {
	# charge le réseau de Petri
	set cTPN [wsc_loadTPN $nomFichier]
	# créer la zone initiale
	set cSState [ssc_initial_zone $cTPN]

    } else {
		# charge le réseau de Petri
		set cTPN [loadTPN $nomFichier]
		if {$methode==1} {
			# créer la zone initiale
			set cSState [initial_zone $cTPN]
   		 } else {
			# créer la zone initiale
			set cSState [sc_initial_zone $cTPN]
   		 }
	}

	# liste de transitions sensibilisées
	set cTPN_EnabledTransList [getEnabledTransitions $cTPN]
	set cTPN_FirableTransList [getFirableTransitions $cSState]
    
}

proc quitterSimulate {} {
    global tabPlace tabJeton ok fin tpn
    global simulator scheduling typePN

#    if {($simulator(gpn))&&($scheduling)} {
#	set retour [gpns_finalPolka]
#    }
    destroy .fenetreSimul
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$ok} {
	    set tabPlace($tpn,$i,jeton) $tabJeton($i)
	}
    }
}


proc resetSimul {c nomFichier} {
    global tabPlace tabJeton ok fin tpn
    global methode scheduling parameters typePN
    global cTPN
    global cSState
    global cTPN_EnabledTransList
    global cTPN_FirableTransList

    if {$methode==1} {set zoneClass "zone"} else {set zoneClass "class"}
    afficheSimu "-------------\n "
    afficheSimu [format [mc ">Restarting simulation with initial marking and initial %s"]  $zoneClass]
    afficheSimu "\n "
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$ok} {
	    set tabPlace($tpn,$i,jeton) $tabJeton($i)
	}
    }
    initSimulation $nomFichier
	afficheSimu [printDomain $cSState]
    redessinerRdP $c

}


proc enabled {i} {
    global cTPN_EnabledTransList
    
	return [contains $cTPN_EnabledTransList $i]
}

proc firable {i} {
    global cTPN_FirableTransList
    
	return [contains $cTPN_FirableTransList $i]
}

proc boutonSimTPN {w c} {
    global simulatorOn

    destroy $w.barreHaut.simulate
    destroy $w.barreHaut.edit 
    button $w.barreHaut.simulate -text [mc "Simulate"] -command "simulateTPN $w $c" -state disabled
    pack configure $w.barreHaut.simulate -side right -padx 5  

    button $w.barreHaut.edit -text [mc "Edit"] -command "editTPN $w $c" -state normal
    pack configure $w.barreHaut.edit -side right -padx 5 
}

proc quitterSimulBrutalement {} {
    editTPN .romeo.global .romeo.global.frame.c
}

proc editTPN {w c} {
    global simulatorOn
    global tabPlace tabJeton ok fin tpn
    affiche "\n"
    affiche [mc "-Stopping simulator..."]
    quitterSimulate
    set simulatorOn 0
    destroy $w.barreHaut.simulate
    destroy $w.barreHaut.edit 
    button $w.barreHaut.simulate -text [mc "Simulate"] -command "simulateTPN $w $c" -state normal
    pack configure $w.barreHaut.simulate -side right -padx 5  

    button $w.barreHaut.edit -text [mc "Edit"] -command "editTPN $w $c" -state disabled
    pack configure $w.barreHaut.edit -side right -padx 5 
    redessinerRdP $c
    affiche "ok" 
}
