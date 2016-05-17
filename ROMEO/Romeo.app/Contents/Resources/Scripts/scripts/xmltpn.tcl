# procedure du parsing xml
# lireAttribut, elementDebut, elementFin
# insererPlace, insererTransition, arcPlaceTransition, arcTransitionPlace
# razElementCourant, ouvrirPointXML
# ajusteTaille


#********************** lire la valeur d'un attribut *********************

proc lireAttribut {liste attribut defaut} {
    if {[lsearch $liste $attribut]!=-1} {
	return [lindex $liste [expr [lsearch $liste $attribut]+1]]
    } else {return $defaut}
}

#********************** ouverture de balise *****************************

proc elementDebut {nomBalise attributs args } {
    global idPC idTC
    global labelC initialMarkingC
    global xC yC
    global eftC lftC eftPC lftPC obsC
    global minC maxC
    global deltaxC deltayC
    global gammaC omegaC
    global typeArcC xnailC ynailC
    global weightArc 
    global couleur
    global infini
    global moduloP moduloT conserverCouleur
    global tabColor
    global constraintC
    global synchronized

    switch $nomBalise {
	place {
	    set idPC [expr [lireAttribut $attributs id 0] + $moduloP]
	    set labelC [lireAttribut $attributs label "P$idPC"]
	    set eftPC [lireAttribut $attributs eft 0]
	    set lftPC [lireAttribut $attributs lft inf]
	    set initialMarkingC [lireAttribut $attributs initialMarking 0]
	}
	transition {
	    set idTC [expr [lireAttribut $attributs id 0] + $moduloT]
	    set labelC [lireAttribut $attributs label "T$idTC"]
	    set eftC [lireAttribut $attributs eft 0]
	    set lftC [lireAttribut $attributs lft 0]
	    set minC [lireAttribut $attributs eft_param ""]
	    set maxC [lireAttribut $attributs lft_param ""]
	    set obsC [lireAttribut $attributs obs 1]
	}
	arc {
	    set idPC [expr [lireAttribut $attributs place 0] + $moduloP]
	    # set idPC [lireAttribut $attributs place error]
	    set idTC [expr [lireAttribut $attributs transition 0] + $moduloT]
	    #	set idTC [lireAttribut $attributs transition error]
	    set typeArcC [lireAttribut $attributs type error]
	    set weightArc [lireAttribut $attributs weight error]
	}
	position {
	    set xC [lireAttribut $attributs x 100]
	    set yC [lireAttribut $attributs y 100]
	}
	deltaLabel {
	    set deltaxC [lireAttribut $attributs deltax 0]
	    set deltayC [lireAttribut $attributs deltay 0]
	}
	scheduling {
	    set gammaC [lireAttribut $attributs gamma 0]
	    set omegaC [lireAttribut $attributs omega 0]
	}
        constraint {
	    set constraintC [lireAttribut $attributs left ""]
	    set constraintC [format "%s %s" $constraintC [lireAttribut $attributs op ""]]
	    set constraintC [format "%s %s" $constraintC [lireAttribut $attributs right ""]]

            set constraintC [string map -nocase {
		"LowerOrEqual"      "<="
		"GreaterOrEqual"      ">="
		"Lower"       "<"
		"Greater"       ">"
		"Equal"	   "="
	    } $constraintC]
	}
	misc {
	}
	nail {
	    set xnailC  [lireAttribut $attributs xnail 0]
	    set ynailC  [lireAttribut $attributs ynail 0]
	}
	TPN {
	}
	graphics {
	    set couleur  [lireAttribut $attributs color 0]
	}
	colorPlace {
	 if {$conserverCouleur==0} {
      for {set i 0} {$i <= 5} {incr i} {
	    set tabColor(Place,$i)  [lireAttribut $attributs c$i 0]
      }
     }  
    }  
	colorTransition {
	 if {$conserverCouleur==0} {
      for {set i 0} {$i <= 5} {incr i} {
	    set tabColor(Transition,$i)  [lireAttribut $attributs c$i 0]
      } 
     } 
	}
	colorArc {
	 if {$conserverCouleur==0} {
      for {set i 0} {$i <= 5} {incr i} {
	    set tabColor(Arc,$i)  [lireAttribut $attributs c$i 0]
      }
     }  
	}
	synchronization {
            set synchronized [lireAttribut $attributs listSynch 0]
	}
	preferences {
	}
	default {
	    erreurFichier $nomBalise TPN
	}
    }
}

proc procData {data} {
}

#********************** fermeture de balise *****************************

proc elementFin {nomBalise} {
    global tabPlace tabTransition tabConstraint
    global tpn
    global nbProcesseur
    global nbConstraints
    global fin ok infini
    global idPC idTC
    global labelC initialMarkingC
    global eftC lftC eftPC lftPC
    global minC maxC obsC
    global xC yC
    global deltaxC deltayC
    global gammaC omegaC
    global typeArcC xnailC ynailC
    global weightArc 
    global couleur
    global constraintC
    global synchronized


    switch $nomBalise {
	place {
	    insererPlace $idPC
	    set tabPlace($tpn,$idPC,dmin) $eftPC
	    if {[string compare $lftPC "infini"]&&[string compare $lftPC "inf"]} {
		set tabPlace($tpn,$idPC,dmax) $lftPC
	    } else {
		set tabPlace($tpn,$idPC,dmax) $infini
	    }
	    set tabPlace($tpn,$idPC,statut) $ok
	    set tabPlace($tpn,$idPC,color) $couleur
	    set tabPlace($tpn,$idPC,label,nom) $labelC
	    set tabPlace($tpn,$idPC,label,dx) $deltaxC
	    set tabPlace($tpn,$idPC,label,dy) $deltayC
	    set tabPlace($tpn,$idPC,processeur) $gammaC
	    set tabPlace($tpn,$idPC,priorite) $omegaC
	    set tabPlace($tpn,$idPC,jeton) $initialMarkingC
	    set tabPlace($tpn,$idPC,xy,x) $xC
	    set tabPlace($tpn,$idPC,xy,y) $yC
	    if {$nbProcesseur($tpn) < $gammaC} {set nbProcesseur($tpn) $gammaC}
	    razElementCourant
	}
	transition {
	    insererTransition $idTC
	    set tabTransition($tpn,$idTC,statut) $ok
	    set tabTransition($tpn,$idTC,color) $couleur
	    set tabTransition($tpn,$idTC,dmin) $eftC
	    if {[string compare $lftC "infini"]&&[string compare $lftC "infinity"]&&[string compare $lftC "inf"]} {
		set tabTransition($tpn,$idTC,dmax) $lftC
	    } else {
		set tabTransition($tpn,$idTC,dmax) $infini
	    }
	    set tabTransition($tpn,$idTC,minparam) $minC
	    set tabTransition($tpn,$idTC,maxparam) $maxC
	    set tabTransition($tpn,$idTC,label,nom) $labelC
	    set tabTransition($tpn,$idTC,label,dx) $deltaxC
	    set tabTransition($tpn,$idTC,label,dy) $deltayC
	    set tabTransition($tpn,$idTC,xy,x) $xC
	    set tabTransition($tpn,$idTC,xy,y) $yC
	    set tabTransition($tpn,$idTC,obs) $obsC
	    razElementCourant
	}
	arc {
	    insererTransition $idTC
	    insererPlace $idPC
	    if {[string compare $typeArcC "TransitionPlace"]} {
		arcPlaceTransition $idPC $idTC $xnailC $ynailC $weightArc $typeArcC $couleur
	    } else {
		arcTransitionPlace $idPC $idTC $xnailC $ynailC $weightArc $couleur
	    }
	    razElementCourant
	}
	position {
	}
	deltaLabel {
	}
	scheduling {
	}
        constraint {
	    if {[string length $tabConstraint($tpn,0)] == 0 } {
		set idCC 0
	    } else {
		set idCC $nbConstraints($tpn)
	        incr nbConstraints($tpn)
	    }
	    set tabConstraint($tpn,$idCC) $constraintC
	    razElementCourant
	}
	default {
	}
    }
}

#********************** inserer une place dans le tableau *******************

proc insererPlace {indicePlace} {
    global tabPlace tpn
    global fin ok destroy
    global insertTPN
    global infini


    for {set j 1} {$tabPlace($tpn,$j,statut)!=$fin} {incr j} {}
    if {$j <= $indicePlace} {
	set tabPlace($tpn,[expr $indicePlace+1],statut) $fin
	for {set i $j} {$i <= $indicePlace} {incr i} {
	    set tabPlace($tpn,$i,statut) $destroy
	}
    }
    if {$tabPlace($tpn,$indicePlace,statut)!=$ok} {
    	set tabPlace($tpn,$indicePlace,statut) $ok
    	set tabPlace($tpn,$indicePlace,color) 0
        set tabPlace($tpn,$indicePlace,label,nom) "not defined"
   	set tabPlace($tpn,$indicePlace,label,dx) 0
   	set tabPlace($tpn,$indicePlace,label,dy) 0
   	set tabPlace($tpn,$indicePlace,processeur) 0
   	set tabPlace($tpn,$indicePlace,priorite) 0
   	set tabPlace($tpn,$indicePlace,jeton) 0
   	set tabPlace($tpn,$indicePlace,xy,x) 100
   	set tabPlace($tpn,$indicePlace,xy,y) 100
	set tabPlace($tpn,$indicePlace,dmin) 0
	set tabPlace($tpn,$indicePlace,dmax) $infini

    }
}

#********************** inserer une transition dans le tableau *******************

proc insererTransition {indiceTransition} {
    global tabTransition tpn
    global fin ok destroy
    global insertTPN
    global infini

    for {set j 1} {$tabTransition($tpn,$j,statut)!=$fin} {incr j} {}
    if {$j <= $indiceTransition} {
	set tabTransition($tpn,[expr $indiceTransition+1],statut) $fin
	for {set i $j} {$i <= $indiceTransition} {incr i} {
	    set tabTransition($tpn,$i,statut) $destroy
	}
    }
    if {$tabTransition($tpn,$indiceTransition,statut)!=$ok} {
	set tabTransition($tpn,$indiceTransition,statut) $ok
	set tabTransition($tpn,$indiceTransition,color) 0
	set tabTransition($tpn,$indiceTransition,dmin) 0
	set tabTransition($tpn,$indiceTransition,dmax) $infini
	set tabTransition($tpn,$indiceTransition,minparam) ""
	set tabTransition($tpn,$indiceTransition,maxparam) ""
	set tabTransition($tpn,$indiceTransition,label,nom) "not defined"
	set tabTransition($tpn,$indiceTransition,Porg,1) 0
	set tabTransition($tpn,$indiceTransition,PorgWeight,1) 0
	set tabTransition($tpn,$indiceTransition,PorgNailx,1) 0
	set tabTransition($tpn,$indiceTransition,PorgNaily,1) 0
	set tabTransition($tpn,$indiceTransition,PorgColor,1) 0
	set tabTransition($tpn,$indiceTransition,Pdes,1) 0
	set tabTransition($tpn,$indiceTransition,PdesWeight,1) 0
	set tabTransition($tpn,$indiceTransition,PdesNailx,1) 0
	set tabTransition($tpn,$indiceTransition,PdesNaily,1) 0
	set tabTransition($tpn,$indiceTransition,PdesColor,1) 0
	set tabTransition($tpn,$indiceTransition,label,dx) 10
	set tabTransition($tpn,$indiceTransition,label,dy) 10
	set tabTransition($tpn,$indiceTransition,xy,x) 100
	set tabTransition($tpn,$indiceTransition,xy,y) 100
	set tabTransition($tpn,$indiceTransition,obs) 1
    }
}

#********************** ajouter un arc *******************

proc arcTransitionPlace {IP IT xnail ynail weight color} {
    global tabPlace tpn
    global tabTransition
    global fin ok destroy

    set existeDeja 0

    for {set j 1} {$tabTransition($tpn,$IT,Pdes,$j) >0}   {incr j} {
	if {$tabTransition($tpn,$IT,Pdes,$j) == $IP} {set existeDeja 1}
    }
    if {$existeDeja==0} {
	set tabTransition($tpn,$IT,Pdes,$j) $IP
	set tabTransition($tpn,$IT,PdesWeight,$j) $weight
	set tabTransition($tpn,$IT,PdesNailx,$j) $xnail
	set tabTransition($tpn,$IT,PdesNaily,$j) $ynail
	set tabTransition($tpn,$IT,PdesColor,$j) $color
	set tabTransition($tpn,$IT,Pdes,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PdesNailx,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PdesNaily,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PdesWeight,[expr $j+1]) 1      
	set tabTransition($tpn,$IT,PdesColor,[expr $j+1]) $color
    }
}

proc arcPlaceTransition {IP IT xnail ynail weight type color} {
    global tabPlace tpn
    global tabTransition
    global fin ok destroy

    set existeDeja 0

    for {set j 1} {$tabTransition($tpn,$IT,Porg,$j) >0}   {incr j} {
	if {($tabTransition($tpn,$IT,Porg,$j) == $IP)&&($tabTransition($tpn,$IT,PorgType,$j)==[retrouverType $type])} { set existeDeja 1 }
    }
    if {$existeDeja==0} {
	set tabTransition($tpn,$IT,Porg,$j) $IP
	set tabTransition($tpn,$IT,PorgWeight,$j) $weight
	set tabTransition($tpn,$IT,PorgNailx,$j) $xnail
	set tabTransition($tpn,$IT,PorgNaily,$j) $ynail
	set tabTransition($tpn,$IT,PorgColor,$j) $color
	set tabTransition($tpn,$IT,Porg,[expr $j+1]) 0
    set tabTransition($tpn,$IT,PorgType,$j) [retrouverType $type]
    set tabTransition($tpn,$IT,PorgNailx,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PorgNaily,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PorgWeight,[expr $j+1]) 1
	set tabTransition($tpn,$IT,PorgType,[expr $j+1]) 0
	set tabTransition($tpn,$IT,PorgColor,[expr $j+1]) $color
    }
}


proc retrouverType {type} {
 
 if {![string compare $type "PlaceTransition"]} {
	    set res 0
	} elseif {![string compare $type "flush"]} {
	    set res 1
	} elseif {![string compare $type "read"]} {
	    set res 2
	} elseif {![string compare $type "logicalInhibitor"]} {
	    set res 3
	} elseif {![string compare $type "timedInhibitor"]} {
	    set res 4
	} else { 
	    set res 0
	}
  return $res
}

#*************** raz des variables de parsing ***************************

proc razElementCourant {} {
    global idPC idTC
    global labelC initialMarkingC
    global eftC lftC eftPC lftPC
    global minC maxC
    global xC yC
    global deltaxC deltayC
    global gammaC omegaC
    global typeArcC xnailC ynailC
    global weightArc 
    global couleur
    global constraintC

    set idPC 0
    set idTC 0
    set xC 100
    set yC 100
    set minC 0
    set maxC 0
    set labelC 0
    set initialMarkingC 0
    set deltaxC 20
    set deltayC 20
    set gammaC 0
    set omegaC 0
    set typeArcC 0
    set xnailC 0
    set ynailC 0
    set weightArc 0
    set couleur 0
    set constraintC 0
}


#***************************** ouvrir file.xml ****************************
# si file =0 alors il ouvre la fenetre tkopenfile

proc ouvrirPointXML {w c insererTPN file} {
    global env
    global nomRdP
    global home
    global cheminFichiers
    global francais
    global tabPlace
    global tabTransition tpn parameters
    global tabConstraint
    global nbConstraints
    global nbProcesseur
    global fin ok destroy
    global modif 
    global maxX
    global maxY
    # les parametres de la place en cours de définition
    global idPC idTC
    global labelC initialMarkingC
    global xC yC
    global deltaxC deltayC
    global gammaC omegaC
    global typeArcC xnailC ynailC
    global weightArc 
    global couleur tabColor
    global parser
    global moduloP moduloT simulatorOn conserverCouleur
    global synchronized

  if {$simulatorOn==1} {
    affiche "\n "
    affiche [mc "-Warning: Not allowed - Quit simulator first"]
  } else {
    set types {{"TPN file"     {.xml}      TEXT}}
    

  queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0

    
	if {![string compare $file "0"]} {
	   set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types ]
	}
	if {[string compare $file ""]} {

	    #** souris en sablier
            $c configure -cursor watch
            update

	    # ******** recherche d'un parser XML **************

            if {[catch {package require expat 1.0}]} {
                if {[catch {package require xml}]} {
                    error [mc "Unable to load a XML parser"]
                    set button [tk_messageBox -icon error -message "Unable to load a XMLparser \n\nInstall    \"expat\" \n          or   \"ActiveTcl8.3.4.1\""]
                } else { set parser [::xml::parser] }
            } else {
		set parser [expat xmlparser]
            }
	    $parser configure -elementstartcommand elementDebut -characterdatacommand procData -elementendcommand elementFin
	    

	    
	    # **********************************************

	    #     set fichier [slach "$file"]
	    set fichier $file


	    # set nbProcesseur($tpn) 0

	    # Statut des places : ok, detroy, ou fin

	    if {$insererTPN} {
	    set conserverCouleur 1
		for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {}
		set moduloP $i
		for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} {}
		set moduloT $i
		affiche "\n "
		affiche [format [mc "-merging PN with %s ..."] $fichier]
		set modif($tpn) 1
	    } else {
	        # ******* obtenir un onglet et l'affecter à tpn *****************
	        nouvelOnglet $w $file
             	# ******* reinitialisation du RDP *****************
	        set conserverCouleur 0
		set nomRdP($tpn) $fichier
		set moduloP 0
		set moduloT 0
		set tabPlace($tpn,1,statut) $fin
		set tabTransition($tpn,1,statut) $fin
		set tabConstraint($tpn,0) ""
		set nbConstraints($tpn) 1
		set nbProcesseur($tpn) 0
		queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0
#		$w.ligneDuBas.indication.nomRdp config -text [format [mc "TPN: %s"] $nomRdP($tpn)]
		affiche "\n"
		affiche  [mc "-Opening "]
		afficheBleu " $fichier"
		affiche  " ..."
		set modif($tpn) 0

	    }
	    
	    razElementCourant
	    set file [open $fichier r]
	    set xmldata [read $file]
	    $parser parse $xmldata
	    close $file
            initParikh $tpn
	    heritageOuPas $tpn
	    if {[ajusteTaille]} {
		save_preferences
		destroy $w
		procedurePlace 
	    } else {
		redessinerRdP $c
	    }
	    #*** souris normal  (plus en sablier)***
	    $c configure -cursor arrow
	    affiche [mc "done"]
	    update
	    
	}
 }
}


proc parserPointXML {leTPN file} {
    global env
    global nomRdP
    global modif
    global home
    global cheminFichiers
    global francais
    global tabPlace
    global tabTransition tpn
    global tabConstraint
    global nbConstraints
    global nbProcesseur 
    global fin ok destroy
    global modif
    global maxX
    global maxY
    # les parametres de la place en cours de définition
    global idPC idTC
    global labelC initialMarkingC
    global xC yC
    global deltaxC deltayC
    global gammaC omegaC
    global typeArcC xnailC ynailC
    global weightArc 
    global couleur tabColor
    global parser
    global moduloP moduloT simulatorOn conserverCouleur
    global synchronized

set saveTPN $tpn
 set tpn $leTPN

    set types {{"TPN file"     {.xml}      TEXT}}
       if {![string compare $file "0"]} {
	   set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types ]
	}
	if {[string compare $file ""]} {

	    # ******** recherche d'un parser XML **************

            if {[catch {package require expat 1.0}]} {
                if {[catch {package require xml}]} {
                    error [mc "Unable to load a XML parser"]
                    set button [tk_messageBox -icon error -message "Unable to load a XMLparser \n\nInstall    \"expat\" \n          or   \"ActiveTcl8.3.4.1\""]
                } else { set parser [::xml::parser] }
            } else {
		set parser [expat xmlparser]
            }
	    $parser configure -elementstartcommand elementDebut -characterdatacommand procData -elementendcommand elementFin
	    

	    
	    # **********************************************

	    #     set fichier [slach "$file"]
	    set fichier $file

		set nomRdP($tpn) $fichier
		set moduloP 0
		set moduloT 0
		set tabPlace($tpn,1,statut) $fin
		set tabTransition($tpn,1,statut) $fin
		set tabConstraint($tpn,0) ""
		set nbConstraints($tpn) 1
		set nbProcesseur($tpn) 0
	    razElementCourant
	    set file [open $fichier r]
	    set xmldata [read $file]
	    $parser parse $xmldata
	    close $file
            set tpn $saveTPN 

 }
}


#        }
#}

proc erreurFichier {balise attendu} {
    .romeo.frame.c configure -cursor ""
    update
    affiche "\n *error : \"$balise\" founded"
    error "\"$balise\" founded ??? not a $attendu file"
    set button [tk_messageBox -icon error -message "this file isn't a $attendu file"]
}

proc ajusteTaille {} {
    global maxX maxY
    set changeTaille 0
    if {$maxX < [tailleX]+50} {
	set maxX [expr [tailleX]+50]
	set changeTaille 1
    }
    if {$maxY < [tailleY]+50} {
	set maxY [expr [tailleY]+50]
	set changeTaille 1
    }
    if {$maxX < 600} {
	set maxX 600
	set changeTaille 1
    }
    if {$maxY < 350} {
	set maxY 350
	set changeTaille 1
    }
    if {$maxX > 5000} {
	set maxX 5000
	set changeTaille 1
    }
    if {$maxY > 5000} {
	set maxY 5000
	set changeTaille 1
    }
    return $changeTaille
}


#*****************************************parse property *********************************************

proc elementDebutProperty {nomBalise attributs } {
    global theProperty
    global ligneProperty
    
    switch $nomBalise {
	Properties {
	}
	place {
	    set indicePlace [lireAttribut $attributs id 0]
	    set operator [lireAttribut $attributs op 0]
	    set valeur [lireAttribut $attributs value 0]
	    if {[string compare $ligneProperty ""]} {
		set ligneProperty "$ligneProperty and M($indicePlace) [convertOperator $operator] $valeur"  
	    } else {  set ligneProperty "M($indicePlace) [convertOperator $operator] $valeur"   }
	}
	MarkingCondition {
	    set ligneProperty ""
	}
	default { 
	    erreurFichier $nomBalise Property
	}
    }
}

proc procDataProperty {data} {
}

#********************** fermeture de balise *****************************

proc elementFinProperty {nomBalise} {
    global theProperty
    global ligneProperty
    
    switch $nomBalise {
	Properties {
	}
	place {
	}
	MarkingCondition {
	    if {[string compare $theProperty ""]} {
		set theProperty "$theProperty or $ligneProperty"  
	    } else {  set theProperty $ligneProperty }
	}
	default { 
	    erreurFichier $nomBalise
	}
	default {
	}
    }
}


proc ouvrirPropertyXml {} {
    global env
    global nomRdP
    global home
    global cheminFichiers
    global parser
    global theProperty
    global fileProperty
    
    set theProperty ""  
    set types {
	{"Property file"     {.xml}      TEXT}
    }
    set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types ]
    if {[string compare $file ""]} {

	# ******** recherche d'un parser XML **************

	if {[catch {package require expat 1.0}]} {
	    if {[catch {package require xml}]} {
		error "unable to load a XMLparser"
		set button [tk_messageBox -icon error -message "Unable to load a XMLparser \n\n\
Install    \"expat\" \n          or   \"ActiveTcl8.3.4.1\""]
	    } else { set parser [::xml::parser] }
	} else {
	    set parser [expat xmlparser]
	}
	$parser configure -elementstartcommand elementDebutProperty \
	    -characterdatacommand procDataProperty -elementendcommand elementFinProperty

	
	# **********************************************
	set fichier $file

	set file [open $fichier r]
	set xmldataProperty [read $file]
	$parser parse $xmldataProperty
	close $file 
	set fileProperty $fichier
    }
    return $theProperty
}


proc convertOperator {operator} {

    switch $operator {
	Greater  { set op ">" }
	Lower  { set op "<"  }
	GreaterOrEqual { set op ">=" }
	LowerOrEqual { set op "<="   }
	Equal  { set op "="   }
	default {
	    set op ERREUR
	    #     puts $comp
	}
    }
    return $op
}



