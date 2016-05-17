proc isSynchronized {numTransition} {
global synchronized
    set resul 0
    for {set i 0} {$i<[llength $synchronized]} {incr i} {
	if {[lsearch [lindex $synchronized $i] $numTransition] > -1} {
	   set resul 1
       }
    }
return $resul

}

proc deleteTransInSynch {numTransition} {
global synchronized
    for {set i 0} {$i<[llength $synchronized]} {incr i} {
	if {[lsearch [lindex $synchronized $i] $numTransition] > -1} {
	    set laListe [lreplace [lindex $synchronized $i] [lsearch [lindex $synchronized $i] $numTransition]  [lsearch [lindex $synchronized $i] $numTransition] ]
	    if {[llength $laListe]>1} {
		set synchronized [lreplace $synchronized $i [expr $i+1] $laListe]
	    } else {
		#supprimer synchro a un seul element ??????
		set synchronized [lreplace $synchronized $i $i]
		set i [expr $i-1]
	    }
       }
    }
}


proc isInFuncSynch {listeSynch numTransition} {
    set resul -1
    for {set i 0} {$i<[llength $listeSynch]} {incr i} {
	if {[lsearch [lindex $listeSynch $i] $numTransition] > -1} {
	   set resul $i
       }
    }
return $resul
}

proc fonctionSynchro {listeSynch numTransition} {

    set resul [list]
    for {set i 0} {$i<[llength $listeSynch]} {incr i} {
	if {[lsearch [lindex $listeSynch $i] $numTransition] > -1} {
	    lappend resul [lindex $listeSynch $i]
	}
    }
return $resul
}

proc defineSynchro {forg numTransition} {
global tabTransition tpn 
global synchronized
global listeSynchLocal
global tabSynchLocal
global fin ok

    set fs .synchronizationVectors
    catch {destroy $fs}
    toplevel $fs

    frame $fs.listeSynchro  -relief ridge -bd 4
    label $fs.listeSynchro.titre
    pack $fs.listeSynchro.titre -side top
    $fs.listeSynchro.titre config -text "A transition involved in a synchronization vector \n must be fired within one list of transitions \n \n Synchronisation vectors :"

# indide -1 pour avoir un vecteur libre
    for {set i -1} {$i<[llength $synchronized]} {incr i} {
    set newline 1
      for {set j 1} {$tabTransition($tpn,$j,statut)!=$fin} {incr j} {
	if {$tabTransition($tpn,$j,statut)==$ok} {
	    if {[lsearch [lindex $synchronized $i] $j]> -1} {
		set tabSynchLocal($i,$j) 1
	    } else {
		set tabSynchLocal($i,$j) 0
	    }
	    if {$newline} {
	      frame $fs.listeSynchro.$i
              pack  $fs.listeSynchro.$i -side top
	      set newline 0
            }
	    checkbutton $fs.listeSynchro.$i.$j -text $j  -variable tabSynchLocal($i,$j) \
	   -relief flat -anchor w -selectcolor red -command "verifierSynch $i $j"
           pack $fs.listeSynchro.$i.$j -side left -pady 2 -anchor w
        }
      }
    }
    pack $fs.listeSynchro -side left 
    frame $fs.indice  -relief ridge -bd 4
    afficheIndiceTransition $fs.indice
    pack $fs.indice -side right

    bind $fs <Return> "validerSynch $forg $fs $numTransition"
    bind $fs <Escape> "destroy $fs"
    frame $fs.buttons
    pack $fs.buttons -side bottom -fill x -pady 2m
    button $fs.buttons.annuler -text Cancel -command  "destroy $fs"
#    button $fs.buttons.test -text test -command  "deleteTransInSynch $numTransition"
    button $fs.buttons.accepter -default active -text "  Ok  " \
		-command "validerSynch $forg $fs $numTransition"
    pack $fs.buttons.accepter $fs.buttons.annuler  -side left -expand 1
#    pack $fs.buttons.test
}

proc validerSynch {f1 f2 numTransition} {
 global tabTransition tpn
 global tabSynchLocal
 global listeSynchLocal
 global synchronized
 global ok fin

    set listeSynchLocal [list]
    for {set i -1} {$i<[llength $synchronized]} {incr i} {
    set uneFonction [list]
     for {set j 1} {$tabTransition($tpn,$j,statut)!=$fin} {incr j} {
	if {$tabTransition($tpn,$j,statut)==$ok} {
	    if {$tabSynchLocal($i,$j)==1} {
		lappend uneFonction $j
	    }
	}
     }
	if {[llength $uneFonction]>1} {lappend listeSynchLocal $uneFonction}
    }

    

    # destroy $f1.synchro.etat
    if {[isInFuncSynch $listeSynchLocal $numTransition]>-1} {
	$f1.synchro.etat config -text [fonctionSynchro  $listeSynchLocal $numTransition]
	} else {
	     $f1.synchro.etat config -text "no synchronization"
	}    

set synchronized  $listeSynchLocal
destroy $f2
}

proc verifierSynch {nL nT} {
 global tabTransition tpn 
 global tabSynchLocal
 global infini
 global parameters

 if {$parameters==0} {	
    if {!(($tabTransition($tpn,$nT,dmin)==0)&&(($tabTransition($tpn,$nT,dmax)==0)||($tabTransition($tpn,$nT,dmax)==$infini)))} {
	if {$tabTransition($tpn,$nT,dmax)==$infini} { set bomax "infty\["} else {set bomax $tabTransition($tpn,$nT,dmax)\]}
        set button [tk_messageBox -icon error -message  "Only \[0,0\] or \[0,infty\[ transition is allowed in synchronization function. \n Here :\[$tabTransition($tpn,$nT,dmin),$bomax"] 
        set tabSynchLocal($nL,$nT) 0
    }
 } else {
     if {!(((![string compare $tabTransition($tpn,$nT,minparam) "0"])||(![string compare $tabTransition($tpn,$nT,minparam) ""]))&&((![string compare $tabTransition($tpn,$nT,maxparam) ""])||(![string compare $tabTransition($tpn,$nT,maxparam) "0"])||(![string compare $tabTransition($tpn,$nT,maxparam) "$infini"])))} {
	if {$tabTransition($tpn,$nT,maxparam)==""} { set bomax "infty\["} else {set bomax $tabTransition($tpn,$nT,maxparam)\]}
        set button [tk_messageBox -icon error -message  "Only \[0,0\] or \[0,infty\[ transition is allowed in synchronization function. \n Here :\[$tabTransition($tpn,$nT,minparam),$bomax"] 
        set tabSynchLocal($nL,$nT) 0
    }
 }}
proc afficheIndiceTransition {fs} {
    global tabTransition tpn 
    global fin
    global ok
    global infini

    text $fs.text -yscrollcommand "$fs.vscroll set" -setgrid true \
	-width 20 -height 8
    scrollbar $fs.vscroll -command "$fs.text yview"
    # -xscrollcommand "$fi.hscroll set"
    # scrollbar $fi.hscroll -orient horiz -command "$fi.text xview"


    pack $fs.vscroll -side right -fill y
    pack $fs.text -expand yes -fill both
    # pack $fi.hscroll -side bottom -fill x

    $fs.text tag configure rouge -foreground red
    $fs.text tag configure surgris -background #a0b7ce
    $fs.text tag configure souligne -underline on


    $fs.text insert end "  Transition             \n" souligne
    $fs.text insert end "Index " surgris
    $fs.text insert end "  \"label\" \n" rouge


    # place par place
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabTransition($tpn,$i,statut)==$ok} {
	    $fs.text insert end "$i     " surgris
	    $fs.text insert end "  \"$tabTransition($tpn,$i,label,nom)\"\n" rouge
	}
    }
}
