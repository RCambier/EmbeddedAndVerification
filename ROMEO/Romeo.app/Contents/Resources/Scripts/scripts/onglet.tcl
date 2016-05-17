


proc existOnglets {nameT} {
global listeOnglets

 if {[lsearch $listeOnglets(tpn) $nameT] > -1} { 
     set indice [lsearch $listeOnglets(tpn) $nameT]
     return [lindex $listeOnglets(indice) $indice]
 } else { return -1}

}


proc changeNameOngletCourant {w nouveauNom} {
global listeOnglets
global tpn

  set indice [lsearch $listeOnglets(indice) $tpn]
 set ancienNom [lindex $listeOnglets(tpn) $indice]

  set listeOnglets(tpn) [lreplace $listeOnglets(tpn) $indice $indice $nouveauNom]

  if {$tpn>=0} {
    $w.onglet.onglet$tpn configure -text [nomSeul $nouveauNom]  -command "changerOngletCourant $w $nouveauNom"
  } else {
    nouvelOnglet $w $nouveauNom -state disabled
  }

  redessinerRdP $w.frame.c
}


proc alone {liste} {

# alone si il y a 0 ou 1 elements dans la liste
    if {[llength $liste]<2} {
      return 1
    } else {
      return 0
    }
}

proc nouvelOnglet {w unTPN} {
global listeOnglets
global tpn

global simulatorOn 


 if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {
    set newIndice 0
    if {[llength $listeOnglets(indice)]>0} {
        $w.onglet.onglet$tpn configure -state normal
    }
    if {[lsearch $listeOnglets(tpn) $unTPN] < 0} { 
       while {[lsearch $listeOnglets(indice) $newIndice] > -1} {
          incr newIndice 
        }
        set listeOnglets(tpn) [linsert $listeOnglets(tpn)  0 $unTPN]
        set listeOnglets(indice) [linsert $listeOnglets(indice)  0 $newIndice]
        
        set tpn $newIndice
        button $w.onglet.onglet$newIndice -text [nomSeul $unTPN] -command "changerOngletCourant $w {$unTPN}" -state disabled
        
#       grid $w.onglet.onglet$newIndice 
        pack configure $w.onglet.onglet$newIndice -side left 
     }
  } 
#$w.onglet configure -background yellow -bd 2
}

#----------------------------------
# unTPN est le nom complet du reseau de Petri
proc delOnglet {w unTPN} {
global listeOnglets
global tpn
global simulatorOn 

 if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {
    set indice [lsearch $listeOnglets(tpn) $unTPN]
    set numBouton [lindex $listeOnglets(indice) $indice]

    if {$indice > -1} { 
        set listeOnglets(tpn) [lreplace $listeOnglets(tpn) $indice $indice]
        set listeOnglets(indice) [lreplace $listeOnglets(indice) $indice $indice]
     } 
     destroy $w.onglet.onglet$numBouton
  }
}

#----------------------------------
# nouveauTPN est le nom complet du reseau de Petri
proc changerOngletCourant {w nouveauTPN} {
global tpn
global listeOnglets

global simulatorOn 


 if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {
    $w.onglet.onglet$tpn configure -state normal

    set indice [lsearch $listeOnglets(tpn) $nouveauTPN]
    set tpn [lindex $listeOnglets(indice) $indice]

    $w.onglet.onglet$tpn configure -state disabled 

    redessinerRdP $w.frame.c
  }
}


proc fermerOngletCourrant {w c} {
global tpn
global listeOnglets

global simulatorOn 

 if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {

  if {[fautIlSauver]} {
     set indice [lsearch $listeOnglets(indice) $tpn]
     set listeOnglets(tpn) [lreplace $listeOnglets(tpn) $indice $indice]
     set listeOnglets(indice) [lreplace $listeOnglets(indice) $indice $indice]
     destroy $w.onglet.onglet$tpn
     if {[llength $listeOnglets(indice)]>0} {
        set tpn [lindex $listeOnglets(indice) 0]
        $w.onglet.onglet$tpn configure -state disabled
        redessinerRdP $w.frame.c
     } else {
        nouveauRdP $w $c
     }
   }
 }
}

proc ouvrirOnglet {w c} {
global tpn listeOnglets
global simulatorOn cheminFichiers
global parikhVector
global tabPlace tabTransition fin

 if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {
     set types {{"TPN file"     {.xml}      TEXT}}
     set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types ]
     if {[string compare $file ""]} {
       if {[existOnglets $file]>-1} {
            affiche "\n -Warning: $file is already opened"
       } else {
            if {$tpn>0} {
              $w.onglet.onglet$tpn configure -state disabled
            }
            ouvrirPointXML $w $c 0 $file
	    if {[existOnglets "noName.xml"]>-1} {
		set indice [lsearch $listeOnglets(tpn) "noName.xml"]
		set numTPN [lindex $listeOnglets(indice) $indice]
		if {($tabTransition($numTPN,1,statut)==$fin)&&($tabPlace($numTPN,1,statut)==$fin)} {
		    delOnglet $w noName.xml
		}
	    }    
       }
     }
  }
}

