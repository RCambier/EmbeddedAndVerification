# les procedures de modification du TPN et donc des tableaux tabPlace, tabTransition ...
#  creationPlace crationTransition....

#++operation sur les NOEUDS :
#  modifPositionNoeud , ajouterNoeudPT ajouterNoeudTP

#++ operation sur les ARCS :
#  supprimerArcPlaceTransition supprimerArcTransitionPlace

#++ DOUBLE CLICK sur place ou sur transition  : Definition des places, transitions ....
#++ REORDONNER TABLEAU PLACE ET TRANSITION :toutCommeYFaut

# dupliquerPlace dupliquerTransition...


#********************operation sur les NOEUDS***************

proc modifPositionNoeud {xa ya numNoeud} {
    global tabTransition tpn
    global tabFlechePT tabFlecheTP tabNoeud
    global fin
    
    if {$tabNoeud($numNoeud,TP)==-1} {
	  set T $tabFlechePT($tabNoeud($numNoeud,arc),transition)
	  set P $tabFlechePT($tabNoeud($numNoeud,arc),place)
	  set type $tabFlechePT($tabNoeud($numNoeud,arc),type)
 	  for {set i 1} { ($tabTransition($tpn,$T,Porg,$i) != $P)||($tabTransition($tpn,$T,PorgType,$i)!=$type)}  {incr i} {}
	  set tabTransition($tpn,$T,PorgNailx,$i) $xa
	  set tabTransition($tpn,$T,PorgNaily,$i) $ya
    } else {
	  set T $tabFlecheTP($tabNoeud($numNoeud,arc),transition)
	  set P $tabFlecheTP($tabNoeud($numNoeud,arc),place)
	  for {set i 1} { $tabTransition($tpn,$T,Pdes,$i) != $P}  {incr i} {}
	  set tabTransition($tpn,$T,PdesNailx,$i) $xa
	  set tabTransition($tpn,$T,PdesNaily,$i) $ya
    }
}


proc modifRelativePositionNoeud {relX relY numNoeud} {
    global tabTransition tpn
    global tabFlechePT tabFlecheTP tabNoeud
    global fin
    
    if {$tabNoeud($numNoeud,TP)==-1} {
	  set T $tabFlechePT($tabNoeud($numNoeud,arc),transition)
	  set P $tabFlechePT($tabNoeud($numNoeud,arc),place)
	  set type $tabFlechePT($tabNoeud($numNoeud,arc),type)
	  for {set i 1} {($tabTransition($tpn,$T,Porg,$i) != $P)||($tabTransition($tpn,$T,PorgType,$i) != $type)}  {incr i} {}
	  set tabTransition($tpn,$T,PorgNailx,$i) [expr $tabTransition($tpn,$T,PorgNailx,$i) + $relX]
	  set tabTransition($tpn,$T,PorgNaily,$i) [expr $tabTransition($tpn,$T,PorgNaily,$i) + $relY]
    } else {
	  set T $tabFlecheTP($tabNoeud($numNoeud,arc),transition)
	  set P $tabFlecheTP($tabNoeud($numNoeud,arc),place)
	  for {set i 1} { $tabTransition($tpn,$T,Pdes,$i) != $P}  {incr i} {}
	  set tabTransition($tpn,$T,PdesNailx,$i) [expr $tabTransition($tpn,$T,PdesNailx,$i) + $relX]
	  set tabTransition($tpn,$T,PdesNaily,$i) [expr $tabTransition($tpn,$T,PdesNaily,$i) + $relY]
    }
}


proc supprimerNoeud {numNoeud} {
    global tabTransition tpn
    global tabFlechePT tabFlecheTP tabNoeud
    global destroy
    global fin
    global ok
    
    if {$tabNoeud($numNoeud,TP)==-1} {
	set T $tabFlechePT($tabNoeud($numNoeud,arc),transition)
	set P $tabFlechePT($tabNoeud($numNoeud,arc),place)
    set type $tabFlechePT($tabNoeud($numNoeud,arc),type)
	for {set j 1} {($tabTransition($tpn,$T,Porg,$j) != $P)||($tabTransition($tpn,$T,PorgType,$j) != $type)}  {incr j} {}
	set tabTransition($tpn,$T,PorgNailx,$j) 0
	set tabTransition($tpn,$T,PorgNaily,$j) 0
    } else {
	set T $tabFlecheTP($tabNoeud($numNoeud,arc),transition)
	set P $tabFlecheTP($tabNoeud($numNoeud,arc),place)
	for {set j 1} {$tabTransition($tpn,$T,Pdes,$j) != $P}  {incr j} {}
	set tabTransition($tpn,$T,PdesNailx,$j) 0
	set tabTransition($tpn,$T,PdesNaily,$j) 0
    }
}

# ajouter un noeud dans un arc ++++++++++++

proc ajouterNoeudPT {P T type xa ya} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif
    
    set modif($tpn) 1
    for {set j 1} { $tabTransition($tpn,$T,Porg,$j) >0}  {incr j} {
        if {($tabTransition($tpn,$T,Porg,$j)==$P)&&($tabTransition($tpn,$T,PorgType,$j)==$type)} {
	    set tabTransition($tpn,$T,PorgNailx,$j) $xa
	    set tabTransition($tpn,$T,PorgNaily,$j) $ya
        }
    }
}


proc ajouterNoeudTP {T P xa ya} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif


    set modif($tpn) 1    
    for {set j 1} { $tabTransition($tpn,$T,Pdes,$j) >0}  {incr j} {
        if {$tabTransition($tpn,$T,Pdes,$j)==$P} {
	    set tabTransition($tpn,$T,PdesNailx,$j) $xa
	    set tabTransition($tpn,$T,PdesNaily,$j) $ya
        }
    }
}


#********************operation sur les ARCS ***************

proc supprimerArcPlaceTransition {P T type} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif

    set modif($tpn) 1    
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
	set onDecale 0
	for {set j 1} { $tabTransition($tpn,$T,Porg,$j) >0}  {incr j} {
	    if {($tabTransition($tpn,$T,Porg,$j)==$P)&&($tabTransition($tpn,$T,PorgType,$j)==$type)} {set onDecale 1}
	    if {$onDecale==1} {
		set tabTransition($tpn,$T,Porg,$j) $tabTransition($tpn,$T,Porg,[expr $j+1])
		set tabTransition($tpn,$T,PorgNailx,$j) $tabTransition($tpn,$T,PorgNailx,[expr $j+1])
		set tabTransition($tpn,$T,PorgNaily,$j) $tabTransition($tpn,$T,PorgNaily,[expr $j+1])
		set tabTransition($tpn,$T,PorgWeight,$j) $tabTransition($tpn,$T,PorgWeight,[expr $j+1])
		set tabTransition($tpn,$T,PorgType,$j) $tabTransition($tpn,$T,PorgType,[expr $j+1])
		set tabTransition($tpn,$T,PorgColor,$j) $tabTransition($tpn,$T,PorgColor,[expr $j+1])
	    }
	}
    }
}

proc supprimerArcTransitionPlace {T P} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif
    
    set modif($tpn) 1
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
	set onDecale 0
	for {set j 1} { $tabTransition($tpn,$T,Pdes,$j) >0}  {incr j} {
	    if {$tabTransition($tpn,$T,Pdes,$j)==$P} {set onDecale 1}
	    if {$onDecale==1} {
		set tabTransition($tpn,$T,Pdes,$j) $tabTransition($tpn,$T,Pdes,[expr $j+1])
		set tabTransition($tpn,$T,PdesNailx,$j) $tabTransition($tpn,$T,PdesNailx,[expr $j+1])
		set tabTransition($tpn,$T,PdesNaily,$j) $tabTransition($tpn,$T,PdesNaily,[expr $j+1])
		set tabTransition($tpn,$T,PdesWeight,$j) $tabTransition($tpn,$T,PdesWeight,[expr $j+1])
		set tabTransition($tpn,$T,PdesColor,$j) $tabTransition($tpn,$T,PdesColor,[expr $j+1])
	    }
	}
    }
}

proc ajouterArcPlaceTransition {laPlace laTransition type} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif
    global couleurCourante
    set existeDeja 0
    
    set modif($tpn) 1
    for {set j 1} {$tabTransition($tpn,$laTransition,Porg,$j) >0}   {incr j} {
	if {($tabTransition($tpn,$laTransition,Porg,$j) == $laPlace)&&($tabTransition($tpn,$laTransition,PorgType,$j)==$type)} {
	    set existeDeja 1 
	    if {$tabTransition($tpn,$laTransition,PorgType,$j)==0} {      
		if {$tabTransition($tpn,$laTransition,PorgWeight,$j) == 0} {        
		    set tabTransition($tpn,$laTransition,PorgWeight,$j) [expr $tabTransition($tpn,$laTransition,PorgWeight,$j)+1]
		}
	    }
	}
    }
    if {$existeDeja==0} {
	set tabTransition($tpn,$laTransition,Porg,$j) $laPlace
	set tabTransition($tpn,$laTransition,PorgNailx,$j) 0
	set tabTransition($tpn,$laTransition,PorgNaily,$j) 0
	set tabTransition($tpn,$laTransition,PorgWeight,$j) 1
	set tabTransition($tpn,$laTransition,PorgType,$j) $type
	set tabTransition($tpn,$laTransition,PorgColor,$j) $couleurCourante(Arc)
	set tabTransition($tpn,$laTransition,Porg,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PorgNailx,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PorgNaily,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PorgWeight,[expr $j+1]) 1
	set tabTransition($tpn,$laTransition,PorgType,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PorgColor,[expr $j+1]) $couleurCourante(Arc)
    }
}

proc ajouterArcTransitionPlace {laTransition laPlace} {
    global tabTransition tpn
    global destroy
    global fin
    global ok modif
    global couleurCourante
    
    set modif($tpn) 1
    set existeDeja 0
    for {set j 1} {$tabTransition($tpn,$laTransition,Pdes,$j) >0}   {incr j} {
	if {$tabTransition($tpn,$laTransition,Pdes,$j) == $laPlace} {
	    set existeDeja 1
	    set tabTransition($tpn,$laTransition,PdesWeight,$j) [expr $tabTransition($tpn,$laTransition,PdesWeight,$j)+1]
	}
    }
    if {$existeDeja==0} {
	set tabTransition($tpn,$laTransition,Pdes,$j)  $laPlace
	set tabTransition($tpn,$laTransition,PdesNailx,$j) 0
	set tabTransition($tpn,$laTransition,PdesNaily,$j) 0
	set tabTransition($tpn,$laTransition,PdesWeight,$j) 1
	set tabTransition($tpn,$laTransition,PdesColor,$j) $couleurCourante(Arc)
	set tabTransition($tpn,$laTransition,Pdes,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PdesNailx,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PdesNaily,[expr $j+1]) 0
	set tabTransition($tpn,$laTransition,PdesWeight,[expr $j+1]) 1
	set tabTransition($tpn,$laTransition,PdesColor,[expr $j+1]) $couleurCourante(Arc)
	set modif($tpn) 1
    }
}

#********************operation sur les PLACES ***************

# ************************ CREER PLACE **************************

proc creationPlace  {c absi ordo} {
    global tabPlace tpn
    global fin ok
    global infini
    global modif
    global couleurCourante
    
    set modif($tpn) 1
    for {set i 1} {$tabPlace($tpn,$i,statut)==$ok} {incr i} {}
    if {$tabPlace($tpn,$i,statut)==$fin} {set tabPlace($tpn,[expr $i+1],statut) $fin}
    set tabPlace($tpn,$i,statut) $ok
    set tabPlace($tpn,$i,color) $couleurCourante(Place)
    set tabPlace($tpn,$i,xy,x) $absi
    set tabPlace($tpn,$i,xy,y) $ordo
    set tabPlace($tpn,$i,label,nom) "P $i"
    set tabPlace($tpn,$i,label,dx) 10
    set tabPlace($tpn,$i,label,dy) 10
    set tabPlace($tpn,$i,processeur) 0
    set tabPlace($tpn,$i,priorite) 0
    set tabPlace($tpn,$i,jeton) 0
    set tabPlace($tpn,$i,dmin) 0
    set tabPlace($tpn,$i,dmax) $infini

    
    redessinerRdP $c
}

# ********************* SUPPRIMER PLACE ***********************

proc supprimerPlace {numPlace} {
    global tabTransition tpn
    global tabPlace
    global destroy
    global fin
    global ok modif

    set modif($tpn) 1    
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
	
	if {$tabTransition($tpn,$i,statut) == $ok} {
	    set onDecale 0
	    for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} {
		if {$tabTransition($tpn,$i,Porg,$j)==$numPlace} {set onDecale 1}
		
		if {$onDecale==1} {
		    set tabTransition($tpn,$i,Porg,$j) $tabTransition($tpn,$i,Porg,[expr $j+1])
		    if {$tabTransition($tpn,$i,Porg,[expr $j+1])!=0} {
			set tabTransition($tpn,$i,PorgNailx,$j) $tabTransition($tpn,$i,PorgNailx,[expr $j+1])
			set tabTransition($tpn,$i,PorgNaily,$j) $tabTransition($tpn,$i,PorgNaily,[expr $j+1])
			set tabTransition($tpn,$i,PorgWeight,$j) $tabTransition($tpn,$i,PorgWeight,[expr $j+1])
			set tabTransition($tpn,$i,PorgType,$j) $tabTransition($tpn,$i,PorgType,[expr $j+1])
			set tabTransition($tpn,$i,PorgColor,$j) $tabTransition($tpn,$i,PorgColor,[expr $j+1])
		    }
		}
	    }
	    set onDecale 0
	    for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} {
		if {$tabTransition($tpn,$i,Pdes,$j)==$numPlace} {set onDecale 1}
		if {$onDecale==1} {
		    set tabTransition($tpn,$i,Pdes,$j) $tabTransition($tpn,$i,Pdes,[expr $j+1])
		    if {$tabTransition($tpn,$i,Pdes,[expr $j+1])!=0} {
			set tabTransition($tpn,$i,PdesNailx,$j) $tabTransition($tpn,$i,PdesNailx,[expr $j+1])
			set tabTransition($tpn,$i,PdesNaily,$j) $tabTransition($tpn,$i,PdesNaily,[expr $j+1])
			set tabTransition($tpn,$i,PdesWeight,$j) $tabTransition($tpn,$i,PdesWeight,[expr $j+1])
			set tabTransition($tpn,$i,PdesColor,$j) $tabTransition($tpn,$i,PdesColor,[expr $j+1])
		    }
		}
	    }
	}
    }
    set tabPlace($tpn,$numPlace,statut) $destroy
}

# ********************* CREER TRANSITION ***********************
proc creationTransition  {c absi ordo} {
    global tabTransition tpn
    global fin
    global ok infini
    global modif
    global couleurCourante
    global parikhVector

    
    set modif($tpn) 1
    for {set i 1} {$tabTransition($tpn,$i,statut)==$ok} {incr i} {}
    
    if {$tabTransition($tpn,$i,statut)==$fin} {set tabTransition($tpn,[expr $i+1],statut) $fin}
    set tabTransition($tpn,$i,statut) $ok
    set tabTransition($tpn,$i,color) $couleurCourante(Transition)
    set tabTransition($tpn,$i,xy,x) $absi
    set tabTransition($tpn,$i,xy,y) $ordo
    set tabTransition($tpn,$i,Porg,1) 0
    set tabTransition($tpn,$i,PorgNailx,1) 0
    set tabTransition($tpn,$i,PorgNaily,1) 0
    set tabTransition($tpn,$i,PorgWeight,1) 1
    set tabTransition($tpn,$i,PorgType,1) 0
    set tabTransition($tpn,$i,PorgColor,1) $couleurCourante(Arc)
    set tabTransition($tpn,$i,Pdes,1) 0
    set tabTransition($tpn,$i,PdesNailx,1) 0
    set tabTransition($tpn,$i,PdesNaily,1) 0
    set tabTransition($tpn,$i,PdesWeight,1) 1
    set tabTransition($tpn,$i,PdesColor,1) $couleurCourante(Arc)
    set tabTransition($tpn,$i,label,nom) "T $i"
    set tabTransition($tpn,$i,label,dx) 10
    set tabTransition($tpn,$i,label,dy) 10
    
    set tabTransition($tpn,$i,dmin) 0
    set tabTransition($tpn,$i,dmax) $infini
    set tabTransition($tpn,$i,minparam) ""
    set tabTransition($tpn,$i,maxparam) ""
    set tabTransition($tpn,$i,obs) 1
  set parikhVector($tpn,$i) 0

    redessinerRdP $c
}

# ********************* SUPPRIMER TRANSITION ***********************
proc supprimerTransition  {numTransition} {
    global tabTransition tpn
    global destroy
    global modif
    global synchronized
    
    set modif($tpn) 1
    set tabTransition($tpn,$numTransition,statut) $destroy
    deleteTransInSynch $numTransition
}

# ********************* supprimer transition inutil car juste status destroy ***********************


#*******************************---- DOUBLE CLICK ----***********************************

# ***************** Double Click sur une place *****************

proc doubleClickP {c numPlace} {
    global plot
    global tabPlace tpn
    global nbProcesseur
    global resultat
    global nouveauNom
    global nbJeton
    global bornemin bornemax infini
    global modif
    global prio
    global typePN
    global francais
    global resultat
    global maxX maxY zoom
    global simulatorOn
    global tabColor resultatCouleur couleurCourante

 if {$simulatorOn!=1} {
  if {![placeDansLaSelection $c $numPlace]} {
	set fp .fenetrePlace
	catch {destroy $fp}
	toplevel $fp 

    wm title $fp "Place Parameters"
	
	set deltaX [lindex [$c xview] 0]
	set x [expr int(($tabPlace($tpn,$numPlace,xy,x)-$maxX*$deltaX)*$zoom +[winfo rootx $c]) -25]
	set deltaY [lindex [$c yview] 0]
	set y [expr int(($tabPlace($tpn,$numPlace,xy,y)-$maxY*$deltaY)*$zoom+[winfo rooty $c]) - 25 ]
	wm geometry $fp +$x+$y
	
	label $fp.indice
	pack $fp.indice -side top
	$fp.indice config -text "Index : $numPlace"
	
	frame $fp.nom -bd 2
	entry $fp.nom.saisieNom -justify left -textvariable nouveauNom -relief sunken -width 40 -bg white
	label $fp.nom.label
	pack $fp.nom.saisieNom -side right
	pack $fp.nom.label -side left
	$fp.nom.label config -text Label:
	
	set nouveauNom $tabPlace($tpn,$numPlace,label,nom)
	set bornemin $tabPlace($tpn,$numPlace,dmin)
        if {$tabPlace($tpn,$numPlace,dmax) == $infini} {
	    set bornemax ""
	} else {
	    set bornemax $tabPlace($tpn,$numPlace,dmax)
	}
	
	pack $fp.nom -side top -fill x
	bind $fp <Return> "validerP $c $fp $numPlace"
	
	set nbJeton $tabPlace($tpn,$numPlace,jeton)
	
	frame $fp.jeton -bd 2
	entry $fp.jeton.saisieJeton -justify left -textvariable nbJeton -relief sunken -width 10 -bg white
	label $fp.jeton.label
	pack $fp.jeton.label -side left
	pack $fp.jeton.saisieJeton -side left
	if {$francais==1} {
	    $fp.jeton.label config -text "nombre de jeton : "
	} else {
	    $fp.jeton.label config -text "number of token : "
	}
	pack $fp.jeton -side top -fill x

# dmin dmax
        if {$typePN==2} {
	    frame $fp.noparam -relief ridge -bd 1 -height 2
	    pack $fp.noparam -side top

	    frame $fp.noparam.dmin -bd 2
	    entry $fp.noparam.dmin.saisieDmin -justify left -textvariable bornemin -relief sunken -width 7 -bg white
	    label $fp.noparam.dmin.label
	    pack $fp.noparam.dmin.label -side left
	    pack $fp.noparam.dmin.saisieDmin -side left
	    $fp.noparam.dmin.label config -text "dmin:  "
	
	    frame $fp.noparam.dmax -bd 2
	
	    label $fp.noparam.dmax.label
	    pack $fp.noparam.dmax.label -side left
	    $fp.noparam.dmax.label config -text "dmax:"
	    pack $fp.noparam.dmin -side top -fill x
	    pack $fp.noparam.dmax -side top -fill x
	

            entry $fp.noparam.dmax.saisieDmax -justify left -textvariable bornemax -relief sunken -width 10 -bg white

	    pack $fp.noparam.dmax.saisieDmax -side left

	    label $fp.noparam.dmax.infini
	    pack $fp.noparam.dmax.infini -side left
           $fp.noparam.dmax.infini config -text [mc "default: infinity"]
	}
# SCHEDULING
	
	if {$typePN==-2} {
	    frame $fp.scheduling -relief ridge -bd 1 -height 2
	    pack $fp.scheduling -side left
	    label $fp.scheduling.label
	    pack $fp.scheduling.label -side top
	    if {$francais==1} {
		$fp.scheduling.label config -text "Extention à l'ordonnancement"
	    } else {
		$fp.scheduling.label config -text "Scheduling extension"
	    }
	    set prio $tabPlace($tpn,$numPlace,priorite)
	    
	    frame $fp.scheduling.priorite -bd 2
	    entry $fp.scheduling.priorite.saisiepriorite -justify left -textvariable prio -relief sunken -width 10 -bg white
	    label $fp.scheduling.priorite.label
	    pack $fp.scheduling.priorite.label -side left
	    pack $fp.scheduling.priorite.saisiepriorite -side left
	    if {$francais==1} {
		$fp.scheduling.priorite.label config -text "priorité :        "
	    } else {
		$fp.scheduling.priorite.label config -text "priority :        "
	    }
	    pack $fp.scheduling.priorite -side top -fill x
	    
	    frame $fp.scheduling.processeur
	    pack $fp.scheduling.processeur  -side left -expand yes -fill y  -pady .5c -padx .5c
	    
	    if {$francais==1} {
		label $fp.scheduling.processeur.label -text "Affectation de la place au processeur :"
	    } else {
		label $fp.scheduling.processeur.label -text "processor (gamma):"
	    }
	    frame $fp.scheduling.processeur.sep -relief ridge -bd 1 -height 2
	    pack $fp.scheduling.processeur.label -side top
	    pack $fp.scheduling.processeur.sep -side top -fill x -expand no
	    
	    set resultat $tabPlace($tpn,$numPlace,processeur)
	    
	    for {set i 0} {$i <= $nbProcesseur($tpn)}   {incr i} {
		if {$francais==1} {
		    if {$i==0} {set Processeur "sans affectation"} else {set Processeur "Processeur $i"}
		} else {
		    if {$i==0} {set Processeur "no"} else {set Processeur "Processor $i"}
		}
		radiobutton $fp.scheduling.processeur.b$i -text $Processeur -variable resultat \
		    -relief flat  -value $i  -width 16 -anchor w -selectcolor red
		pack $fp.scheduling.processeur.b$i  -side top -pady 2 -anchor w -fill x
	    }
	} else {
	    set prio $tabPlace($tpn,$numPlace,priorite)
	    set resultat $tabPlace($tpn,$numPlace,processeur)
	}
	# si pas scheduling on maintient les valeurs (on pourait remettre à zero ?
	
	
	# Gestion des couleurs :
    frame $fp.color -bd 2
    pack $fp.color -side top
	label $fp.color.label
	pack $fp.color.label -side left
	$fp.color.label config -text "color:  "
	    
    set resultatCouleur(Place) $tabPlace($tpn,$numPlace,color)
    selectionCouleur $fp.color Place

	
	bind $fp <Return> "validerP $c $fp $numPlace"
	bind $fp <Escape> "destroy $fp"
	
	frame $fp.buttons
	pack $fp.buttons -side bottom -fill x -pady 2m
	if {$francais==1} {
	    button $fp.buttons.annuler -text Annuler -command  "destroy $fp"
	    button $fp.buttons.accepter -default active -text "Accepter"  \
		-command "validerP $c $fp $numPlace"
	} else {
	    button $fp.buttons.annuler -text Cancel -command  "destroy $fp"
	    button $fp.buttons.accepter -default active -text "  Ok  "  \
		-command "validerP $c $fp $numPlace"
	}
	pack $fp.buttons.accepter $fp.buttons.annuler -side left -expand 1

  }	else {
  # si place dans la selection :  
  changerCouleurSelection $c
  }
 } 
 #fin si notsimulatoron 
 
    proc validerP {c fl numP} {
	global resultat
	global nouveauNom
	global tabPlace tpn
	global bornemin bornemax infini
	global nbJeton
	global modif
	global prio
        global resultatCouleur couleurCourante

	set x [format %d $nbJeton]
	set modif($tpn) 1
		
	set couleurCourante(Place) $resultatCouleur(Place)
	set tabPlace($tpn,$numP,color) $resultatCouleur(Place)
	set tabPlace($tpn,$numP,processeur) $resultat
	set tabPlace($tpn,$numP,label,nom) $nouveauNom
	set tabPlace($tpn,$numP,jeton) $nbJeton
	set tabPlace($tpn,$numP,priorite) $prio

	# if {$parameters==0} {	} A AJOUTER QUAND PARAMETRE AUSSI SUR PLACE
	if {$bornemax == ""} {set bornemax $infini}
	set x [format %d  $bornemin]
	set y [format %d $bornemax]
        if {($x <=0)} {set x 0}
	if {$y > $infini} {set y $infini}
	if {$x >= $y} {set x $y}
	if {$x >= $infini} {set x 0}
          
	set tabPlace($tpn,$numP,dmin) $x
	set tabPlace($tpn,$numP,dmax) $y

	
	#    set button [tk_messageBox -message "Selection \Processeur $resultat\" "]
	destroy $fl
	
	redessinerRdP $c
    }
    
}


# ***************** Double Click sur une transition *****************

proc doubleClickT {c numTransition} {
    global plot
    global tabTransition tpn
    global bornemin
    global bornemax
    global minp
    global maxp
    global nouveauNom
    global modif
    global francais
    global parameters synchronized typePN
    global infini
    global dmaxInfini
    global maxX maxY zoom
    global simulatorOn
    global tabColor resultatCouleur couleurCourante
    global estObservable

    
 if {$simulatorOn==1} {
	simulatorFireTranstion $c $numTransition
 } else {
  if {![transitionDansLaSelection $c $numTransition]} {

	set nouveauNom $tabTransition($tpn,$numTransition,label,nom)
	set bornemin $tabTransition($tpn,$numTransition,dmin)
	set bornemax $tabTransition($tpn,$numTransition,dmax)
	
	set f .fenetreTransition
	catch {destroy $f}
	toplevel $f
	
	set deltaX [lindex [$c xview] 0]
	set x [expr int(($tabTransition($tpn,$numTransition,xy,x)-$maxX*$deltaX)*$zoom +[winfo rootx $c]) - 20]
	set deltaY [lindex [$c yview] 0]
	set y [expr int(($tabTransition($tpn,$numTransition,xy,y)-$maxY*$deltaY)*$zoom +[winfo rooty $c]) - 20]
	wm geometry $f +$x+$y
    wm title $f "Transition parameters"
	
	label $f.indice
	pack $f.indice -side top
	$f.indice config -text "Index : $numTransition"
	frame $f.nom -bd 2
	entry $f.nom.saisieNom -justify left -textvariable nouveauNom -relief sunken -width 30 -bg white
	label $f.nom.label
	pack $f.nom.saisieNom -side right
	pack $f.nom.label -side left
	$f.nom.label config -text Label:
        pack $f.nom -side top -fill x

# ***************** IL SUFFIRA DE DECOMMENTER CETTE PARTIE POUR LA SYNCHRO ********************

#	frame $f.synchro  -relief ridge -bd 2
#	label $f.synchro.titre
#	pack $f.synchro.titre -side top
#        $f.synchro.titre config -text "Synchronization (given by index)"
#        label $f.synchro.etat
#	pack $f.synchro.etat -side left
#	if {[isSynchronized $numTransition]} {
#	    $f.synchro.etat config -text [fonctionSynchro $synchronized $numTransition]
#	} else {
#	     $f.synchro.etat config -text "no synchronization"
#	}    
# 	button $f.synchro.define -text [mc "define"] -command  "defineSynchro $f  $numTransition"
# 	pack $f.synchro.define -side right
#	pack $f.synchro -side top -fill x
# fin de la partie à decommenter

# OBSERVABLE :

        set estObservable  $tabTransition($tpn,$numTransition,obs)
	frame $f.obs -relief ridge -bd 2
	pack $f.obs -side top -fill x

        checkbutton $f.obs.bouton -text "Observable transition"  -variable estObservable -selectcolor red \
	      -relief flat  -width 10 -anchor w 
        pack $f.obs.bouton -side top -fill x

# RAPPEL typePN :   -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn
# NO P-TPN (donc tempo ou parametre sur transition)
	if {($typePN!=2)} {
# NO PARAMETERS -- si par erreur il y a scheduling et parametre, on ne prend pas les parametres
         if {($parameters==0)||($typePN==-2)} {
	    frame $f.noparam -relief ridge -bd 1 -height 2
	    pack $f.noparam -side top

	    frame $f.noparam.dmin -bd 2
	    entry $f.noparam.dmin.saisieDmin -justify left -textvariable bornemin -relief sunken -width 7 -bg white
	    label $f.noparam.dmin.label
	    pack $f.noparam.dmin.label -side left
	    pack $f.noparam.dmin.saisieDmin -side left
	    $f.noparam.dmin.label config -text "dmin:  "
	
	    frame $f.noparam.dmax -bd 2
  	    frame $f.noparam.dmax.resultat -bd 2
	
	    label $f.noparam.dmax.label
	    pack $f.noparam.dmax.label -side left
	    $f.noparam.dmax.label config -text "dmax:"
	    pack $f.noparam.dmin -side top -fill x
	    pack $f.noparam.dmax -side top -fill x
	
	    if {$bornemax == $infini} {
	      set dmaxInfini 1
	      entry $f.noparam.dmax.resultat.saisieDmax -justify left -textvariable rien -relief sunken -width 10 \
		-state disabled 
	    } else {
	      set dmaxInfini 0
	      entry $f.noparam.dmax.resultat.saisieDmax -justify left -textvariable bornemax -relief sunken -width 10 -bg white
	    }
	
	    pack $f.noparam.dmax.resultat.saisieDmax -side left
	
	    checkbutton $f.noparam.dmax.resultat.infini -text "infini"  -variable dmaxInfini -selectcolor red \
	      -relief flat  -width 10 -anchor w -command  "borneMaxInfini $f.noparam.dmax.resultat"
	
	    pack $f.noparam.dmax.resultat.infini -side bottom -pady 2 -anchor w -fill x
	    pack $f.noparam.dmax.resultat -side left
	    set minp $tabTransition($tpn,$numTransition,minparam)
	    set maxp $tabTransition($tpn,$numTransition,maxparam)
# PARAMETERS 
 	  } else {
	    frame $f.parameterized -relief ridge -bd 1 -height 2
	    pack $f.parameterized -side top
	    label $f.parameterized.label
	    pack $f.parameterized.label -side top
            $f.parameterized.label config -text [mc "Parametric Extension"]

	    set minp $tabTransition($tpn,$numTransition,minparam)
	    set maxp $tabTransition($tpn,$numTransition,maxparam)
	    
	    frame $f.parameterized.minparam -bd 2
	    entry $f.parameterized.minparam.saisiemin -justify left -textvariable minp -relief sunken -width 10 -bg white
	    label $f.parameterized.minparam.label
	    pack $f.parameterized.minparam.label -side left
	    pack $f.parameterized.minparam.saisiemin -side left
	    $f.parameterized.minparam.label config -text "min param:        "
	    label $f.parameterized.minparam.infini
	    pack $f.parameterized.minparam.infini -side bottom
            $f.parameterized.minparam.infini config -text [mc "default: 0"]

	    pack $f.parameterized.minparam -side top -fill x

	    frame $f.parameterized.maxparam -bd 2
	    label $f.parameterized.maxparam.label
	    pack $f.parameterized.maxparam.label -side left

            entry $f.parameterized.maxparam.saisieDmax -justify left -textvariable maxp -relief sunken -width 10 -bg white
	
	    pack $f.parameterized.maxparam.saisieDmax -side left
	    $f.parameterized.maxparam.label config -text "max param:        "
	
	    label $f.parameterized.maxparam.infini
	    pack $f.parameterized.maxparam.infini -side bottom
            $f.parameterized.maxparam.infini config -text [mc "default: infinity"]
	    pack $f.parameterized.maxparam -side top -fill x

	  }
	}


# Gestion des couleurs :
    frame $f.color -bd 2
    pack $f.color -side top
	label $f.color.label
	pack $f.color.label -side left
	$f.color.label config -text "color:  "
	    
    set resultatCouleur(Transition) $tabTransition($tpn,$numTransition,color)
    selectionCouleur $f.color Transition

	
	
	bind $f <Return> "validerT $c $f $numTransition"
	bind $f <Escape> "destroy $f"
	frame $f.buttons
	pack $f.buttons -side bottom -fill x -pady 2m
	if {$francais==1} {
	    button $f.buttons.annuler -text Annuler -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "Accepter"  \
		-command "validerT $c $f $numTransition"
	} else {
	    button $f.buttons.annuler -text Cancel -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "  Ok  " \
		-command "validerT $c $f $numTransition"
	}
	pack $f.buttons.accepter $f.buttons.annuler  -side left -expand 1
 } else {
 #si transition dans la selection
 changerCouleurSelection $c
 }
 } 
    
    #++++++ procedures internes à doubleClickT
    
    proc validerT {c fl numT} {
	global resultat
	global nouveauNom
	global bornemin
	global bornemax estObservable
    	global minp
    	global maxp 
	global tabTransition tpn
	global modif
	global infini parameters
        global resultatCouleur couleurCourante
		
  
 set couleurCourante(Transition) $resultatCouleur(Transition)
 set tabTransition($tpn,$numT,color) $resultatCouleur(Transition)
 set  tabTransition($tpn,$numT,obs) $estObservable
 set nouveauNom [retirerListeCar $nouveauNom  [list < >]]

 set modif($tpn) 1
 if {$parameters==0} {	
	set x [format %d  $bornemin]
	set y [format %d $bornemax]
	if {[expr ($bornemin <= $bornemax)&&($bornemin >=0)]} {
            if {$bornemax > $infini} {set bornemax $infini}
   	    set tabTransition($tpn,$numT,dmin) $x
	    set tabTransition($tpn,$numT,dmax) $y
	    set tabTransition($tpn,$numT,label,nom) $nouveauNom
	    destroy $fl
	    redessinerRdP $c
	    
	} else {
	    set button [tk_messageBox -message "Not allowed : Transition $nouveauNom \n \[ $bornemin ; $bornemax \]"]
	}
    } else {  # cad si parameters>=1  ICI il faudra verifier que l'expression est correct a op b avec op in (+,_)
      set minp [retirerListeCar $minp  [list < > & # @ $ . , = % ! ?]]
      set maxp [retirerListeCar $maxp  [list < > & # @ $ . , = % ! ?]]
      if {([sansEspace $maxp]=="infinity")||([sansEspace $maxp]=="inf")} {set maxp ""}

      if {([verifSyntaxeParametre $minp]=="")&&([verifSyntaxeParametre $maxp]=="")} {
         set tabTransition($tpn,$numT,minparam) [gotonext $minp]
         set tabTransition($tpn,$numT,maxparam) [gotonext $maxp]  
         set tabTransition($tpn,$numT,label,nom) $nouveauNom
	 if {[entier [sansEspace $tabTransition($tpn,$numT,minparam)]]} {
	     set tabTransition($tpn,$numT,minparam) [sansEspace $tabTransition($tpn,$numT,minparam)]
         }
	 if {[entier [sansEspace $tabTransition($tpn,$numT,maxparam)]]} {
	     set tabTransition($tpn,$numT,maxparam) [sansEspace $tabTransition($tpn,$numT,maxparam)]
         }
	 if {[entier $tabTransition($tpn,$numT,minparam)]&&[entier $tabTransition($tpn,$numT,maxparam)]} {
	     if {$tabTransition($tpn,$numT,minparam) > $tabTransition($tpn,$numT,maxparam)} {
		 set tabTransition($tpn,$numT,minparam) $tabTransition($tpn,$numT,maxparam)
	     }
	 }
         destroy $fl
         redessinerRdP $c
      } else { 
	  set button [tk_messageBox -icon error -message  "Parametric constraints \[$minp,$maxp\] \n [verifSyntaxeParametre $minp] [verifSyntaxeParametre $maxp]"]
      }
    }
  }
    
    
    proc borneMaxInfini {inf} {
 	global parameters
	global bornemax
	global dmaxInfini maxp
	global infini
	
	destroy $inf.infini
	destroy $inf.saisieDmax
	
	if {$dmaxInfini == 1} {
	    set bornemax $infini
	    entry $inf.saisieDmax -justify left -textvariable rien -relief sunken -width 10 \
		-state disabled 
	} else {
	    set bornemax 0
            entry $inf.saisieDmax -justify left -textvariable bornemax -relief sunken -width 10 -bg white 
	}
	
	pack $inf.saisieDmax -side left
	

	checkbutton $inf.infini -text "infini"  -variable dmaxInfini -selectcolor red \
	    -relief flat  -width 10 -anchor w -command  "borneMaxInfini $inf"
	
	pack $inf.infini -side bottom -pady 2 -anchor w -fill x
#	pack $inf -side left
    }

    
}
# fin doubleClickT


# ************************ REORDONNER TABLEAU PLACE ET TRANSITION **************************


proc toutCommeYFaut  {} {
    global tabPlace
    global tabTransition tpn
    global fin
    global ok
    global destroy
    
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabTransition($tpn,$i,statut)==$destroy} {
	    for {set j $i} {$tabTransition($tpn,$j,statut)!=$fin} {incr j} {
		set tabTransition($tpn,$j,statut) $tabTransition($tpn,[expr $j+1],statut)
		if {$tabTransition($tpn,[expr $j+1],statut)==$ok} {
		    set tabTransition($tpn,$j,xy,x) $tabTransition($tpn,[expr $j+1],xy,x)
		    set tabTransition($tpn,$j,xy,y) $tabTransition($tpn,[expr $j+1],xy,y)
		    set tabTransition($tpn,$j,label,nom) $tabTransition($tpn,[expr $j+1],label,nom)
		    set tabTransition($tpn,$j,label,dx) $tabTransition($tpn,[expr $j+1],label,dx)
		    set tabTransition($tpn,$j,label,dy) $tabTransition($tpn,[expr $j+1],label,dy)
		    set tabTransition($tpn,$j,dmin) $tabTransition($tpn,[expr $j+1],dmin)
		    set tabTransition($tpn,$j,dmax) $tabTransition($tpn,[expr $j+1],dmax)
		    set tabTransition($tpn,$j,minparam) $tabTransition($tpn,[expr $j+1],minparam)
		    set tabTransition($tpn,$j,maxparam) $tabTransition($tpn,[expr $j+1],maxparam)
		    
		    set tabTransition($tpn,$j,Porg,1) $tabTransition($tpn,[expr $j+1],Porg,1)
		    set tabTransition($tpn,$j,PorgNailx,1) $tabTransition($tpn,[expr $j+1],PorgNailx,1)
		    set tabTransition($tpn,$j,PorgNaily,1) $tabTransition($tpn,[expr $j+1],PorgNaily,1)
		    set tabTransition($tpn,$j,PorgWeight,1) $tabTransition($tpn,[expr $j+1],PorgWeight,1)
		    set tabTransition($tpn,$j,PorgType,1) $tabTransition($tpn,[expr $j+1],PorgType,1)
		    for {set l 2} {$tabTransition($tpn,[expr $j+1],Porg,[expr $l-1]) >0} {incr l} {
			set tabTransition($tpn,$j,Porg,$l) $tabTransition($tpn,[expr $j+1],Porg,$l)
			set tabTransition($tpn,$j,PorgNailx,$l) $tabTransition($tpn,[expr $j+1],PorgNailx,$l)
			set tabTransition($tpn,$j,PorgNaily,$l) $tabTransition($tpn,[expr $j+1],PorgNaily,$l)
			set tabTransition($tpn,$j,PorgWeight,$l) $tabTransition($tpn,[expr $j+1],PorgWeight,$l)
			set tabTransition($tpn,$j,PorgType,$l) $tabTransition($tpn,[expr $j+1],PorgType,$l)
		    }
		    set tabTransition($tpn,$j,Pdes,1) $tabTransition($tpn,[expr $j+1],Pdes,1)
		    set tabTransition($tpn,$j,PdesNailx,1) $tabTransition($tpn,[expr $j+1],PdesNailx,1)
		    set tabTransition($tpn,$j,PdesNaily,1) $tabTransition($tpn,[expr $j+1],PdesNaily,1)
		    set tabTransition($tpn,$j,PdesWeight,1) $tabTransition($tpn,[expr $j+1],PdesWeight,1)
		    for {set l 2} {$tabTransition($tpn,[expr $j+1],Pdes,[expr $l-1]) >0} {incr l}  {
			set tabTransition($tpn,$j,Pdes,$l) $tabTransition($tpn,[expr $j+1],Pdes,$l)
			set tabTransition($tpn,$j,PdesNailx,$l) $tabTransition($tpn,[expr $j+1],PdesNailx,$l)
			set tabTransition($tpn,$j,PdesNaily,$l) $tabTransition($tpn,[expr $j+1],PdesNaily,$l)
			set tabTransition($tpn,$j,PdesWeight,$l) $tabTransition($tpn,[expr $j+1],PdesWeight,$l)
		    }
		}
	    }
	    
	}
    }
    
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} {
	for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0} {incr j} {
	    set tabTransition($tpn,$i,Porg,$j) [expr [iPU $tabTransition($tpn,$i,Porg,$j)]+1]
	}
	for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0} {incr j} {
	    set tabTransition($tpn,$i,Pdes,$j) [expr [iPU $tabTransition($tpn,$i,Pdes,$j)]+1]
	}
    }
    
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$destroy} {
	    for {set j $i} {$tabPlace($tpn,$j,statut)!=$fin} {incr j} {
		set tabPlace($tpn,$j,statut)  $tabPlace($tpn,[expr $j+1],statut)
		if {$tabPlace($tpn,[expr $j+1],statut)==$ok} {
		    set tabPlace($tpn,$j,xy,x) $tabPlace($tpn,[expr $j+1],xy,x)
		    set tabPlace($tpn,$j,xy,y) $tabPlace($tpn,[expr $j+1],xy,y)
		    set tabPlace($tpn,$j,label,nom) $tabPlace($tpn,[expr $j+1],label,nom)
		    set tabPlace($tpn,$j,label,dx) $tabPlace($tpn,[expr $j+1],label,dx)
		    set tabPlace($tpn,$j,label,dy)  $tabPlace($tpn,[expr $j+1],label,dy)
		    set tabPlace($tpn,$j,processeur) $tabPlace($tpn,[expr $j+1],processeur)
		    set tabPlace($tpn,$j,priorite) $tabPlace($tpn,[expr $j+1],priorite)
		    set tabPlace($tpn,$j,jeton) $tabPlace($tpn,[expr $j+1],jeton)
		}
	    }
	}
    }
}

proc dupliquerPlace {indice dx dy} {
    global tabPlace tpn
    global fin
    global ok
    global modif
    
    set modif($tpn) 1
    for {set i 1} {$tabPlace($tpn,$i,statut)==$ok} {incr i} {}
    if {$tabPlace($tpn,$i,statut)==$fin} {set tabPlace($tpn,[expr $i+1],statut) $fin}
    set tabPlace($tpn,$i,statut) $ok
    set tabPlace($tpn,$i,xy,x) [expr $tabPlace($tpn,$indice,xy,x)+ $dx]
    set tabPlace($tpn,$i,xy,y) [expr $tabPlace($tpn,$indice,xy,y)+ $dy]
    set tabPlace($tpn,$i,color) $tabPlace($tpn,$indice,color)
    set tabPlace($tpn,$i,dmin) $tabPlace($tpn,$indice,dmin)
    set tabPlace($tpn,$i,dmax) $tabPlace($tpn,$indice,dmax)
    set tabPlace($tpn,$i,label,nom) "$tabPlace($tpn,$indice,label,nom)\_c"
    set tabPlace($tpn,$i,label,dx) $tabPlace($tpn,$indice,label,dx)
    set tabPlace($tpn,$i,label,dy) $tabPlace($tpn,$indice,label,dy)
    set tabPlace($tpn,$i,processeur) $tabPlace($tpn,$indice,processeur)
    set tabPlace($tpn,$i,priorite) $tabPlace($tpn,$indice,priorite)
    set tabPlace($tpn,$i,jeton) $tabPlace($tpn,$indice,jeton)
    return $i
}

proc dupliquerTransition {indice listeP copieP copieN dx dy } {
    global tabTransition tpn
    global fin
    global ok
    global modif
    global tempNoeud
    
    for {set npt 1} {$tempNoeud($npt,placeNPT)>-1} {incr npt} {}
    for {set ntp 1} {$tempNoeud($ntp,placeNTP)>-1} {incr ntp} {}
    
    set modif($tpn) 1
    for {set i 1} {$tabTransition($tpn,$i,statut)==$ok} {incr i} {}
    if {$tabTransition($tpn,$i,statut)==$fin} {set tabTransition($tpn,[expr $i+1],statut) $fin}
    set tabTransition($tpn,$i,statut) $ok
    
    set tabTransition($tpn,$i,color)  $tabTransition($tpn,$indice,color)
    set tabTransition($tpn,$i,xy,x) [expr $tabTransition($tpn,$indice,xy,x)+ $dx]
    set tabTransition($tpn,$i,xy,y) [expr $tabTransition($tpn,$indice,xy,y)+ $dy]
    
    for {set j 1} {$tabTransition($tpn,$indice,Porg,$j)!=0} {incr j} {
	set iPo [lsearch $listeP $tabTransition($tpn,$indice,Porg,$j)]
	if {$iPo<0} {
	    set tabTransition($tpn,$i,Porg,$j) $tabTransition($tpn,$indice,Porg,$j)
	} else {
	    set tabTransition($tpn,$i,Porg,$j) [lindex $copieP $iPo]
	}
	set tabTransition($tpn,$i,PorgWeight,$j) $tabTransition($tpn,$indice,PorgWeight,$j)
	set tabTransition($tpn,$i,PorgType,$j) $tabTransition($tpn,$indice,PorgType,$j)
	set tabTransition($tpn,$i,PorgColor,$j) $tabTransition($tpn,$indice,PorgColor,$j)
	set tabTransition($tpn,$i,PorgNaily,$j) 0
	set tabTransition($tpn,$i,PorgNailx,$j) 0
	
	if {$tabTransition($tpn,$indice,Porg,$j)>0} {
	    set leNoeud [indiceNoeudPT $tabTransition($tpn,$indice,Porg,$j) $indice $tabTransition($tpn,$indice,PorgType,$j)]
	    if {$leNoeud>-1} {
		if {[lsearch $copieN $leNoeud]!=-1} {
		    set tempNoeud($npt,placeNPT) $tabTransition($tpn,$i,Porg,$j)
		    set tempNoeud($npt,type) $tabTransition($tpn,$i,PorgType,$j)
		    set tempNoeud($npt,transitionNPT) $i
		    incr npt
		    set tabTransition($tpn,$i,PorgNaily,$j) [expr $tabTransition($tpn,$indice,PorgNaily,$j) + $dy]
		    set tabTransition($tpn,$i,PorgNailx,$j) [expr $tabTransition($tpn,$indice,PorgNailx,$j) + $dx]
		}
	    }
	}
    }
    
    set tempNoeud($npt,placeNPT) -1
    set tempNoeud($npt,transitionNPT) -1
    set tempNoeud($npt,type) 0
    
    set tabTransition($tpn,$i,Porg,$j) 0
    set tabTransition($tpn,$i,PorgType,$j) 0
    set tabTransition($tpn,$i,PorgWeight,$j) 1
    set tabTransition($tpn,$i,PorgColor,$j) 1
    set tabTransition($tpn,$i,PorgNaily,$j) 0
    set tabTransition($tpn,$i,PorgNailx,$j) 0
    
    for {set j 1} {$tabTransition($tpn,$indice,Pdes,$j)!=0} {incr j} {
	set iPo [lsearch $listeP $tabTransition($tpn,$indice,Pdes,$j)]
	if {$iPo<0} {
	    set tabTransition($tpn,$i,Pdes,$j) $tabTransition($tpn,$indice,Pdes,$j)
	} else {
	    set tabTransition($tpn,$i,Pdes,$j) [lindex $copieP $iPo]
	}
	set tabTransition($tpn,$i,PdesWeight,$j) $tabTransition($tpn,$indice,PdesWeight,$j)
	set tabTransition($tpn,$i,PdesColor,$j) $tabTransition($tpn,$indice,PdesColor,$j)
	set tabTransition($tpn,$i,PdesNailx,$j) 0
	set tabTransition($tpn,$i,PdesNaily,$j) 0
	if {$tabTransition($tpn,$indice,Pdes,$j)>0} {
	    set leNoeud [indiceNoeudTP $indice $tabTransition($tpn,$indice,Pdes,$j)]
	    if {$leNoeud>-1} {
		if {[lsearch $copieN $leNoeud]!=-1} {
		    set tempNoeud($ntp,placeNTP) $tabTransition($tpn,$i,Pdes,$j)
		    set tempNoeud($ntp,transitionNTP) $i
		    incr ntp
		    set tabTransition($tpn,$i,PdesNaily,$j) [expr $tabTransition($tpn,$indice,PdesNaily,$j) + $dy]
		    set tabTransition($tpn,$i,PdesNailx,$j) [expr $tabTransition($tpn,$indice,PdesNailx,$j) + $dx]
		}
	    }
	}
    }
    set tempNoeud($ntp,placeNTP) -1
    set tempNoeud($ntp,transitionNTP) -1
    
    set tabTransition($tpn,$i,Pdes,$j) 0
    set tabTransition($tpn,$i,PdesWeight,$j) 1
    set tabTransition($tpn,$i,PdesColor,$j) 1
    set tabTransition($tpn,$i,PdesNaily,$j) 0
    set tabTransition($tpn,$i,PdesNailx,$j) 0
    
    
    set tabTransition($tpn,$i,label,nom) "$tabTransition($tpn,$indice,label,nom)\_c"
    set tabTransition($tpn,$i,label,dx) $tabTransition($tpn,$indice,label,dx)
    set tabTransition($tpn,$i,label,dy) $tabTransition($tpn,$indice,label,dy)
    
    set tabTransition($tpn,$i,dmin) $tabTransition($tpn,$indice,dmin)
    set tabTransition($tpn,$i,dmax) $tabTransition($tpn,$indice,dmax)
    set tabTransition($tpn,$i,minparam) $tabTransition($tpn,$indice,minparam)
    set tabTransition($tpn,$i,maxparam) $tabTransition($tpn,$indice,maxparam)
    set tabTransition($tpn,$i,obs) $tabTransition($tpn,$indice,obs)

    return $i
}

proc doubleClickFPT {c k} {
    global plot
    global tabTransition tabPlace tpn
    global modif
    global francais
    global maxX maxY zoom
    global tabFlechePT tabFlecheTP tabNoeud
    global fin
    global nouveauWeight
    global simulatorOn
    global couleurCourante tabColor resultatCouleur


    if {$simulatorOn!=1} {
	
	set T $tabFlechePT($k,transition)
	set P $tabFlechePT($k,place)
	set type $tabFlechePT($k,type)
	for {set indice 1} {($tabTransition($tpn,$T,Porg,$indice)!=$P)||($tabTransition($tpn,$T,PorgType,$indice)!=$type)}  {incr indice} {}
	set nouveauWeight $tabTransition($tpn,$T,PorgWeight,$indice)
	
	set f .fenetreArc
	catch {destroy $f}
	toplevel $f
	
	set deltaX [lindex [$c xview] 0]
	set x [expr int(($tabTransition($tpn,$T,xy,x)-$maxX*$deltaX)*$zoom +[winfo rootx $c]) - 20]
	set deltaY [lindex [$c yview] 0]
	set y [expr int(($tabTransition($tpn,$T,xy,y)-$maxY*$deltaY)*$zoom +[winfo rooty $c]) - 20]
	wm geometry $f +$x+$y
    wm title $f "Arc parameters : "
	
	label $f.nom -bd 2
	pack $f.nom -side top -fill x -pady 2m
	
	$f.nom config -text "Type : [nomTypeArc $type]  \n Arc : Place($P) -> transition($T) \n $tabPlace($tpn,$P,label,nom) -> $tabTransition($tpn,$T,label,nom) \n " -justify center
	
	# Si c'est un arc normal ou read ou inhibitor logique
	# cad si ce n'est pas un flush
	if {($type!=1)} {
	  frame $f.weight -bd 2 
	  pack $f.weight -side top -fill x -pady 2m
	  entry $f.weight.saisie -justify left -textvariable nouveauWeight -relief sunken -width 7 -bg white
	  label $f.weight.label
	  pack $f.weight.label -side left
	  pack $f.weight.saisie -side left
	  $f.weight.label config -text "weight:  "
	}
	
    frame $f.color -bd 2
    pack $f.color -side top
	label $f.color.label
	pack $f.color.label -side left
	$f.color.label config -text "color:  "
	    
    set resultatCouleur(Arc) $tabTransition($tpn,$T,PorgColor,$indice)
    selectionCouleur $f.color Arc

	bind $f <Return> "validerArcPT $c $f $T $indice"
	bind $f <Escape> "destroy $f"
	frame $f.buttons
	pack $f.buttons -side bottom -fill x -pady 2m
	if {$francais==1} {
	    button $f.buttons.annuler -text Annuler -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "Accepter"  \
		-command "validerArcPT $c $f $T $indice"
	} else {
	    button $f.buttons.annuler -text Cancel -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "  Ok  " \
		-command "validerArcPT $c $f $T $indice"
	}
	pack $f.buttons.accepter $f.buttons.annuler  -side left -expand 1
    } 
    
    
    #++++++ procedures internes à doubleClickArc
    
    proc validerArcPT {c f numT indice} {
	global nouveauWeight
	global tabTransition tpn
	global modif
	global resultatCouleur couleurCourante
	
	set tabTransition($tpn,$numT,PorgColor,$indice) $resultatCouleur(Arc)
	set couleurCourante(Arc) $resultatCouleur(Arc)
	set res [format %d $nouveauWeight]
	if {$res > 0} {
	    set tabTransition($tpn,$numT,PorgWeight,$indice) $res
	}
    destroy $f
	set modif($tpn) 1
	redessinerRdP $c
    }
}


proc doubleClickFTP {c k} {
    global plot
    global tabTransition tabPlace tpn
    global modif
    global francais
    global maxX maxY zoom
    global tabFlechePT tabFlecheTP tabNoeud
    global fin
    global nouveauWeight
    global simulatorOn
    global couleurCourante tabColor resultatCouleur
    
    if {$simulatorOn!=1} {
	
	set T $tabFlecheTP($k,transition)
	set P $tabFlecheTP($k,place)
	for {set indice 1} { $tabTransition($tpn,$T,Pdes,$indice) != $P}  {incr indice} {}
	set nouveauWeight $tabTransition($tpn,$T,PdesWeight,$indice)
	
	set f .fenetreArc
	catch {destroy $f}
	toplevel $f
	
	set deltaX [lindex [$c xview] 0]
	set x [expr int(($tabTransition($tpn,$T,xy,x)-$maxX*$deltaX)*$zoom +[winfo rootx $c]) -20]
	set deltaY [lindex [$c yview] 0]
	set y [expr int(($tabTransition($tpn,$T,xy,y)-$maxY*$deltaY)*$zoom +[winfo rooty $c]) - 20]
	wm geometry $f +$x+$y
    wm title $f "Arc parameters : "
	
	label $f.nom -bd 2
	pack $f.nom -side top -fill x -pady 2m
	
	$f.nom config -text "Type : TransitionPlace \n Arc : transition($T) -> Place($P) \n $tabTransition($tpn,$T,label,nom) -> $tabPlace($tpn,$P,label,nom) \n"
	
	frame $f.weight -bd 2
	pack $f.weight -side top -fill x -pady 2m
	entry $f.weight.saisie -justify left -textvariable nouveauWeight -relief sunken -width 7 -bg white
	label $f.weight.label
	pack $f.weight.label -side left
	pack $f.weight.saisie -side left
	$f.weight.label config -text "weight:  "

    frame $f.color -bd 2
    pack $f.color -side top
	label $f.color.label
	pack $f.color.label -side left
	$f.color.label config -text "color:  "
	    
    set resultatCouleur(Arc) $tabTransition($tpn,$T,PdesColor,$indice)
    selectionCouleur $f.color Arc	
	
	bind $f <Return> "validerArcTP $c $f $T $indice"
	bind $f <Escape> "destroy $f"
	frame $f.buttons
	pack $f.buttons -side bottom -fill x -pady 2m
	if {$francais==1} {
	    button $f.buttons.annuler -text Annuler -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "Accepter"  \
		-command "validerArcTP $c $f $T $indice"
	} else {
	    button $f.buttons.annuler -text Cancel -command  "destroy $f"
	    button $f.buttons.accepter -default active -text "  Ok  " \
		-command "validerArcTP $c $f $T $indice"
	}
	pack $f.buttons.accepter $f.buttons.annuler  -side left -expand 1
    } 
    #++++++ procedures internes à doubleClickArc
    
    proc validerArcTP {c f numT indice} {
	global nouveauWeight
	global tabTransition tpn
	global modif
	global resultatCouleur couleurCourante
	
	set tabTransition($tpn,$numT,PdesColor,$indice) $resultatCouleur(Arc)
	set couleurCourante(Arc) $resultatCouleur(Arc)
    set res [format %d $nouveauWeight]
	if {$res > 0} {
	    set tabTransition($tpn,$numT,PdesWeight,$indice) $res
	}
    destroy $f
	set modif($tpn) 1
	redessinerRdP $c
    }
}

# ++++++++++++++++++++++++++++++++ LES COULEURS ++++++++++++++++++++++++++++

proc selectionCouleur {f objet} {
global resultatCouleur tabColor

    frame $f.choix -bd 2
    pack $f.choix -side left   
	for {set i 0} {$i <= 5}   {incr i} {
       radiobutton $f.choix.c$i -text "color $i : $tabColor($objet,$i)" -variable resultatCouleur($objet) \
		    -relief flat  -value $i  -width 16 -anchor w -bg $tabColor($objet,$i)
	   pack $f.choix.c$i  -side top -pady 2 -anchor w 
	}
 
}

proc paletteCouleur {f objet} {
global  tabColorLocal

#set tabColor(Place,5) red
	label $f.label -text "$objet:  "
	pack $f.label -side left

    frame $f.choix -bd 2
    pack $f.choix -side left   
	for {set i 0} {$i <= 5}   {incr i} {
 	   frame $f.choix.b$i -bd 2
       pack $f.choix.b$i -side top
	   label $f.choix.b$i.couleur -text color$i -width 12 -bg $tabColorLocal($objet,$i)
	   button $f.choix.b$i.palette -bg yellow -text Palette -command "changeColor $f $objet $i" 
       pack $f.choix.b$i.couleur -side left 
       pack $f.choix.b$i.palette -side left 
	}
 
 }
 
proc changeColor {f objet i} {
global tabColorLocal resultat

 set colorPrec $tabColorLocal($objet,$i) 
 set resultat [tk_chooseColor -initialcolor gray -title "Choose color"]
 if {[string compare $resultat ""]} {
  set tabColorLocal($objet,$i) $resultat
  if {[string compare $colorPrec $tabColorLocal($objet,$i)]} { 
   destroy $f.label
   destroy $f.choix
#   save_preferences
   paletteCouleur $f $objet
  } 
 } 
}

proc defaultPalette {f} {
global tabColorLocal defaultTabColor

  for {set i 0} {$i <= 5}   {incr i} {
    set tabColorLocal(Place,$i) $defaultTabColor(Place,$i)
    set tabColorLocal(Transition,$i) $defaultTabColor(Transition,$i)
    set tabColorLocal(Arc,$i) $defaultTabColor(Arc,$i)
  }

    destroy $f.colorPlace.label
    destroy $f.colorPlace.choix
    paletteCouleur $f.colorPlace Place

    destroy $f.colorTransition.label
    destroy $f.colorTransition.choix
    paletteCouleur $f.colorTransition Transition
    
    destroy $f.colorArc.label
    destroy $f.colorArc.choix
    paletteCouleur $f.colorArc Arc

}

proc saveAsDefaultPalette {} {
global tabColorLocal defaultTabColor

  for {set i 0} {$i <= 5}   {incr i} {
    set defaultTabColor(Place,$i) $tabColorLocal(Place,$i)
    set defaultTabColor(Transition,$i) $tabColorLocal(Transition,$i)
    set defaultTabColor(Arc,$i) $tabColorLocal(Arc,$i)
  }
  
  	save_preferences
}


proc changerCouleurSelection {c} {
    global tabColor  resultatCouleur couleurCourante

    set resultatCouleur(Place) $couleurCourante(Place)  
    set resultatCouleur(Transition) $couleurCourante(Transition)  
    set resultatCouleur(Arc) $couleurCourante(Arc)


    set top .fenetreSelectionCouleur
    catch {destroy $top}
    toplevel $top
    wm title $top "Change colors of the selection bloc:  "

    $top config 

#	label $top.label -text "Change colors of the selection bloc:  "
#	pack $top.label -side top
    frame $top.palette -bd 2 -relief sunken
    pack $top.palette -side top
    frame $top.palette.place -bd 2
    pack $top.palette.place -side left
    frame $top.palette.transition -bd 2
    pack $top.palette.transition -side left
    frame $top.palette.arc -bd 2
    pack $top.palette.arc -side left
    
    label $top.palette.place.label -bd 2 -text "Place"
    pack $top.palette.place.label -side left
    selectionCouleur $top.palette.place Place

    label $top.palette.transition.label -bd 2 -text "Transition"
    pack $top.palette.transition.label -side left
    selectionCouleur $top.palette.transition Transition
 
     label $top.palette.arc.label -bd 2 -text "Arc"
    pack $top.palette.arc.label -side left
    selectionCouleur $top.palette.arc Arc

    bind $top <Return> "validerCouleurSelection $top $c"
    frame $top.buttons 
    pack $top.buttons -side bottom -fill x -pady 2m
    button $top.buttons.annuler -text [mc "Cancel"] -command  "annulerCouleurSelection $top" 
    button $top.buttons.accepter -default active  -text [mc "Apply"]  \
	-command "validerCouleurSelection $top $c"
    pack $top.buttons.accepter $top.buttons.annuler  -side left -expand 1

    # +++ procedures interne à la procedure map

  proc validerCouleurSelection {f c} {
   global couleurCourante resultatCouleur

   set couleurCourante(Place) $resultatCouleur(Place)
   set couleurCourante(Transition) $resultatCouleur(Transition)
   set couleurCourante(Arc) $resultatCouleur(Arc)
   changerCouleurDeLaSelection
   # cette procedure est dans manitag
   
   destroy $f
   redessinerRdP $c

  }

  proc annulerCouleurSelection {f} {
 
	destroy $f
  }


}

