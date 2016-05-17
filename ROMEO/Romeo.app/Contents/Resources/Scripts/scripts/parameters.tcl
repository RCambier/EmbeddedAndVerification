
# procedure associe au menu Parametric-PN : additionalConstraints




#******** ajout de contraintes supplementaires sur les parametres***************

proc additionalConstraints {} {
    global tabConstraint tpn typePN
    global nbConstraints
    global cons
    global nbCons
    global nbSaisie
    global modif
    
    set f .fenetreConstraint
    catch {destroy $f}
    toplevel $f
    wm title $f [mc "Additional constraints"]

    frame $f.description
    label $f.description.titre
    pack $f.description.titre -side top
    $f.description.titre config -text [mc "Add linear constraints on the parameters:"]
    pack $f.description -side top -fill x

    for {set i 0} {$i<$nbConstraints($tpn)} {incr i} { 
	set cons($i) $tabConstraint($tpn,$i)
    }
    set nbCons $nbConstraints($tpn)

    button $f.and -text [mc "and"] -command  "addConstraint $f"
    pack $f.and -side right

    for {set i 0} {$i<$nbConstraints($tpn)} {incr i} {
	frame $f.saisieConstraints($i) -bd 2
	entry $f.saisieConstraints($i).addConstraint -justify left  -textvariable cons($i) -relief sunken -width 20 -bg white
  	button $f.saisieConstraints($i).bclear -text [mc "clear"] -command  "clearConstraint $i $f"
    	pack $f.saisieConstraints($i).bclear -side right
	pack $f.saisieConstraints($i).addConstraint -side left
	pack $f.saisieConstraints($i) -side top -fill x
    }
    set nbSaisie $nbConstraints($tpn)

    bind $f <Return> "validerCons $f"

    frame $f.buttons
    pack $f.buttons -side bottom -fill x -pady 2m
    button $f.buttons.annuler -text [mc "Cancel"] -command  "destroy $f"
    button $f.buttons.accepter -default active -text [mc "Ok"]  -command "validerCons $f"
    pack $f.buttons.annuler $f.buttons.accepter  -side left -expand 1

    # ++++++ procedures internes à la procedure additionalConstraints

    proc validerCons {fl} {
        global tabConstraint
	global cons
	global modif tpn
	global nbConstraints
	global nbCons

	set modif($tpn) 1
        set lesErreurs ""
	set j 0

    	for {set i 0} {$i<$nbCons} {incr i} {
		if {[string length $cons($i)] > 0 } {
		    set erreur [verifSyntaxeContrainte $cons($i)]
                    if {$erreur==""} {
 	                set tabConstraint($tpn,$j) $cons($i)
                    } else { 
			set lesErreurs  "$lesErreurs\Error in constraint: $cons($i) \n      $erreur \n"
			set tabConstraint($tpn,$j) ""
                    }
		    incr j
		}
	}


	if { $j > 0} {
	     set nbConstraints($tpn) $j
	} else {
	     set nbConstraints($tpn) 1
             set tabConstraint($tpn,0) ""
        } 

    if {$lesErreurs!= ""} {
         set button [tk_messageBox -icon error -message  "$lesErreurs"]
    } else {
	destroy $fl
    }
  }

    proc addConstraint {fl} {
	global cons
	global nbCons
        global nbSaisie

	set cons($nbCons) ""	

	frame $fl.saisieConstraints($nbCons) -bd 2
	entry $fl.saisieConstraints($nbCons).addConstraint -justify left -textvariable cons($nbCons) -relief sunken -width 20 -bg white
	pack $fl.saisieConstraints($nbCons).addConstraint -side left
  	button $fl.saisieConstraints($nbCons).bclear -text [mc "clear"] -command  "clearConstraint $nbCons $fl"
    	pack $fl.saisieConstraints($nbCons).bclear -side right
	pack $fl.saisieConstraints($nbCons) -side top -fill x

	incr nbCons
	incr nbSaisie
    }

    proc clearConstraint {li fl} {
	global cons
	global nbCons
        global nbSaisie

	set cons($li) "" 

	if {$nbSaisie > 1} {
		place forget $fl.saisieConstraints($li) 
		set nbSaisie [expr $nbSaisie-1]
	}
    }

    # fin de la procedure additionalConstraints
}


#--------------Quand on ouvre un RdP dans un mode qui n'est pas celui dans lequel il a été cree (parametre ou non)

proc heritageOuPas {lePetri} {
global tabTransition tpn
global fin ok infini

  set paramVide 1
  set tempoVide 1

    for {set i 1} {$tabTransition($lePetri,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($lePetri,$i,statut) == $ok} {
		if {($tabTransition($lePetri,$i,minparam)!= "")||($tabTransition($tpn,$i,maxparam)!= "")} {
  		       set paramVide 0
		}
		if {($tabTransition($lePetri,$i,dmin)!= 0)||($tabTransition($tpn,$i,dmax)!= $infini)} {
		       set tempoVide 0
		}
	}
    }
  if {($paramVide)&&($tempoVide==0)} {
      heriterContrainteTempo 2 $lePetri
  } elseif {$tempoVide} {
      heriterContrainteTempo 0 $lePetri
  }
}

#--------------Quand on bascule de ou vers le mode parametre 
proc  heriterContrainteTempo2 {parametre lePetri} {
global tabTransition tpn
global fin ok infini

  set paramVide 1
  set tempoVide 1

     for {set i 1} {$tabTransition($lePetri,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($lePetri,$i,statut) == $ok} {
		if {($tabTransition($lePetri,$i,minparam)!= "")||($tabTransition($tpn,$i,maxparam)!= "")} {
  		       set paramVide 0
		}
		if {($tabTransition($lePetri,$i,dmin)!= 0)||(($tabTransition($tpn,$i,dmax)!= $infini)&&($tabTransition($tpn,$i,dmax)!= 0))} {
		       set tempoVide 0
		}
	}
    }
    if {(($paramVide)&&($parametre>=1))||(($tempoVide)&&($parametre<1))} {
      heriterContrainteTemporel $parametre $lePetri
    }
}


proc heriterContrainteTempo {parametre lePetri} {
global tabTransition tpn
global fin ok infini
global modif
 
  if {$parametre>=1} {
    for {set i 1} {$tabTransition($lePetri,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($lePetri,$i,statut) == $ok} {
		if {[entier [sansEspace $tabTransition($lePetri,$i,minparam)]]||($tabTransition($lePetri,$i,minparam)== "")} {
		    if {($tabTransition($lePetri,$i,dmin)== 0)} {
			set tabTransition($lePetri,$i,minparam) ""
		    } else {
			set tabTransition($lePetri,$i,minparam) $tabTransition($lePetri,$i,dmin)
		    }
		    set modif($lePetri) 1
                }
	        if {[entier [sansEspace $tabTransition($lePetri,$i,maxparam)]]||($tabTransition($lePetri,$i,maxparam)== "")} {
		    if {($tabTransition($lePetri,$i,dmax)== $infini)} {
			set tabTransition($lePetri,$i,maxparam) ""
		    } else {
		        set tabTransition($lePetri,$i,maxparam) $tabTransition($lePetri,$i,dmax)
                    }
#		    set modif($lePetri) 1
		}
	}
    }
  } else {
    for {set i 1} {$tabTransition($lePetri,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($lePetri,$i,statut) == $ok} {
		if {($tabTransition($lePetri,$i,minparam)!= "")} {
		    if {[entier [sansEspace $tabTransition($lePetri,$i,minparam)]]} {
			set tabTransition($lePetri,$i,dmin)  [sansEspace $tabTransition($lePetri,$i,minparam)]
#			set modif($lePetri) 1
			if {(![entier [sansEspace $tabTransition($lePetri,$i,maxparam)]])&&($tabTransition($lePetri,$i,dmin) > $tabTransition($lePetri,$i,dmax))} {
			   set tabTransition($lePetri,$i,dmax) $tabTransition($lePetri,$i,dmin)
			}
		    }
                } else {
		     if {($tabTransition($lePetri,$i,dmin) != 0)} {
			 set tabTransition($lePetri,$i,dmin) 0
#			 set modif($lePetri) 1
		     }
		}
		if {($tabTransition($lePetri,$i,maxparam)!= "")} {
		    if {[entier [sansEspace $tabTransition($lePetri,$i,maxparam)]]} {
			set tabTransition($lePetri,$i,dmax) [sansEspace $tabTransition($lePetri,$i,maxparam)]
#		        set modif($lePetri) 1
			if {(![entier [sansEspace $tabTransition($lePetri,$i,minparam)]])&&($tabTransition($lePetri,$i,dmin) > $tabTransition($lePetri,$i,dmax))} {
			   set tabTransition($lePetri,$i,dmin) $tabTransition($lePetri,$i,dmax)
			}
		    }
		} else {
		     if {($tabTransition($lePetri,$i,dmax)!= $infini)} {
			 set tabTransition($lePetri,$i,dmax) $infini
#			 set modif($lePetri) 1
		     }
		}
		if {$tabTransition($lePetri,$i,dmin) > $tabTransition($lePetri,$i,dmax)} {
                    set tabTransition($lePetri,$i,dmin)  $tabTransition($lePetri,$i,dmax)
		}	      				       
	}
    }
  }
}