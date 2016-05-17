# ICI
# les procedures associées aux différentes actions sur les tags :
#                   release plotDown, plotMove
# sur les places, transitions, fleches, noeuds (coudes)


# REMARQUE : le double click est dans maniTPN

# TODO TYPE   supprimerArcPlaceTransition ajouterNoeudPT ajouterNoeudPT



#*******************************************************************************************
# Les clicks sur le canvas
#*******************************************************************************************

proc directSurCanvas {w} {

    if {[$w find withtag current]==""} {
	return 1
    } else {
	return 0
    }
}

#*******************************---- PLOT GENERAL ----***********************************

#******************* plotDown, plotMove, posX, posY, moveX, moveY ****************


proc plotDown {w x y} {
    global plot
    global maxX maxY
    global select
    global zoom
    global simulatorOn
    
    if {$simulatorOn==0} {
	
	set deltaX [lindex [$w xview] 0]
	set deltaY [lindex [$w yview] 0]
	set X [expr ($x/$zoom+$maxX*$deltaX)]
	set Y [expr ($y/$zoom+$maxY*$deltaY)]

	set plot(lastX) $X
	set plot(lastY) $Y
	set plot(downX) $X
	set plot(downY) $Y
	set select(x1) $X
	set select(x2) $X
	set select(y1) $Y
	set select(y2) $Y
	#  puts "ici $select(etat)"
	if {$select(etat)} {
	    set select(etat) 0
	    redessinerRdP $w
	} else {
	    # reinitialiser les listes
	    
	    set select(etat) 1

	    etablirListe $w [$w find enclosed $select(x1) $select(y1) $select(x2) $select(y2)]
	    set select(etat) 1
	    $w dtag selected
	    $w addtag selected withtag current
	    $w raise current
	}
    } 
}

proc plotMove {w x y} {
    global plot
    global maxX maxY
    global select
    global modif tpn 
    global simulatorOn
    
    if {$simulatorOn==0} {
	set modif($tpn) 1
	set select(etat) 0
	set depX [moveX $w $x]
	set depY [moveY $w $y]
	$w move selected $depX $depY
    }
}


proc posDownXY {w x y} {
    global plot
    global maxX maxY
    global zoom

    set deltaX [lindex [$w xview] 0]
    set deltaY [lindex [$w yview] 0]
    set X [expr ($x/$zoom+$maxX*$deltaX)]
    set Y [expr ($y/$zoom+$maxY*$deltaY)]

    set plot(lastX) $X
    set plot(lastY) $Y
    set plot(downX) $X
    set plot(downY) $Y
}



proc posX {c x} {
    global maxX
    global plot select
    global zoom

    if {$select(vide)} {
	set limG 8
	set limD 8
    } else {
	set limG  [expr $plot(downX) - [min $select(x1) $select(x2)]]
	set limD  [expr [max $select(x1) $select(x2)] - $plot(downX)]
    }

    set deltaX [lindex [$c xview] 0]
    set xa [expr ($x/$zoom+$maxX*$deltaX)]
    if {$xa<$limG} {set xa $limG}
    if {$xa> [expr $maxX-$limD]} {set xa [expr $maxX-$limD]}
    return $xa
}


proc posY {c y} {
    global plot select
    global maxY
    global zoom

    if {$select(vide)} {
	set limH 8
	set limB 8
    } else {
	set limH  [expr  $plot(downY)- [min $select(y1) $select(y2)]]
	set limB  [expr [max $select(y1) $select(y2)] - $plot(downY)]
    }
    set deltaY [lindex [$c yview] 0]
    set ya [expr ($y/$zoom+$maxY*$deltaY)]
    if {$ya<$limH} {set ya $limH}
    if {$ya> [expr $maxY-$limB]} {set ya [expr $maxY-$limB]}
    return $ya
}

proc posScreenX {c x} {
    global maxX
    global zoom

    set deltaX [lindex [$c xview] 0]
    set xa [expr ($x)*$zoom]
    #     set xa [expr ($x-$maxX*$deltaX)*$zoom]
    return $xa
}
proc posScreenY {c y} {
    global maxY
    global zoom

    set deltaY [lindex [$c yview] 0]
    #     set ya [expr ($y-$maxY*$deltaY)*$zoom]
    set ya [expr ($y)*$zoom]
    return $ya
}


proc moveX {w x}  {
    global plot
    global maxX
    global select zoom

    if {$select(vide)} {
	set limG 8
	set limD 8
    } else {
	set limG  [expr $plot(downX) - [min $select(x1) $select(x2)]]
	set limD  [expr [max $select(x1) $select(x2)] - $plot(downX)]
    }

    set deltaX [lindex [$w xview] 0]
    set X [expr ($x/$zoom+$maxX*$deltaX)]

    if {$X< $limG} {
	set X $limG
	# zoom XX
    } elseif {$X> [expr $maxX-$limD]} {
	set X [expr $maxX-$limD]
    } else {
	set droiteX [lindex [$w xview] 1]
	if {$X > $maxX*$droiteX - 2} {
	    set X [expr $X+($droiteX-$deltaX)*$maxX/10]
	    $w xview scroll 1 units
	} elseif {$X < $maxX*$deltaX + 4} {
	    set X [expr $X-($droiteX-$deltaX)*$maxX/10]
	    $w xview scroll -1 units
	}
    }
    set depX [expr $X-$plot(lastX)]
    set plot(lastX) $X
    return [expr $depX*$zoom]
}

proc moveY {w y}  {
    global plot
    global maxY
    global select
    global zoom

    if {$select(vide)} {
	set limH 8
	set limB 8
    } else {
	set limH  [expr  $plot(downY)- [min $select(y1) $select(y2)]]
	set limB  [expr [max $select(y1) $select(y2)] - $plot(downY)]
    }

    set deltaY [lindex [$w yview] 0]
    set Y [expr ($y/$zoom+$maxY*$deltaY)]

    if {$Y<$limH} {
	set Y $limH
    } elseif {$Y> [expr $maxY-$limB]} {
	set Y [expr $maxY-$limB]
    } else {
	set basY [lindex [$w yview] 1]
	if {$Y > $maxY*$basY - 2} {
	    set Y [expr $Y+($basY-$deltaY)*$maxY/10]
	    $w yview scroll 1 units
	} elseif {$Y < $maxY*$deltaY + 4} {
	    set Y [expr $Y-($basY-$deltaY)*$maxY/10]
	    $w yview scroll -1 units
	}
    }
    set depY [expr $Y-$plot(lastY)]
    set plot(lastY) $Y
    return [expr $depY*$zoom]
}

#***************************************************************************************
# procedure click directement sur le canvas : downSurCanvas moveSurCanvas releaseSurCanvas
#***************************************************************************************

proc moveSurCanvas {w x y} {
    global plot
    global tabPlace tpn
    global tabTransition
    global newFPT
    global newFTP
    global creerLien
    global maxX maxY
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {

	if {$creerLien} {
	    creationLien $w $x $y
	} elseif {$select(etat)} {
	    creationSelection $w $x $y
	}
    } 
}

proc downSurCanvas {w a b} {
    global creerLien
    global creerTransition
    global creerPlace tpn
    global maxX
    global maxY
    global plot
    global select zoom
    global simulatorOn
    
    if {$simulatorOn==0} {
	#  puts $select(red)
	if {$select(red)==0} {set select(vide) 1}
	set xa [posX $w $a]
	set ya [posY $w $b]
	if {$creerLien==1} {
	    set plot(downX) $xa
	    set plot(downY) $ya
	    set plot(lastX) $xa
	    set plot(lastY) $ya
	    creationLien $w $a $b
	} elseif {$creerTransition==1} {
	    creationTransition $w $xa $ya

	} elseif {$creerPlace==1} {
	    creationPlace $w $xa $ya

	} elseif {$select(red)==0} {
	    
	    set select(etat) 1
	    set plot(downX) $xa
	    set plot(downY) $ya
	    set plot(lastX) $xa
	    set plot(lastY) $ya
	    set select(x1) $xa
	    set select(x2) $xa
	    set select(y1) $ya
	    set select(y2) $ya
	    $w delete fenetreSelection
	    $w dtag selected
	    etablirListe $w [$w find enclosed $select(x1) $select(y1) $select(x2) $select(y2)]
	    redessinerRdP $w
	} }
}

proc releaseSurCanvas {w a b} {
    global creerLien
    global creerTransition tpn
    global creerPlace
    global maxX
    global maxY
    global select zoom
    global simulatorOn
    
    if {$simulatorOn==0} {
	if {$select(etat)&&$select(vide)&&!$creerLien} {
	    set select(etat) 0
	    #    moveX $w $a
	    #    moveY $w $b
	    # position exact
	    #zz   set select(x2) [expr [posX $w $a]*$zoom]
	    #zz   set select(y2) [expr [posY $w $b]*$zoom]
	    set select(x2) [posX $w $a]
	    set select(y2) [posY $w $b]
	    $w delete fenetreSelection
	    $w dtag selected

	    # $w addtag selected enclosed $select(x1) $select(y1) $select(x2) $select(y2)
	    etablirListe $w [$w find enclosed [posScreenX $w $select(x1)] [posScreenY $w $select(y1)] [posScreenX $w $select(x2)] [posScreenY $w $select(y2)]]
	    recreerSelected $w
	    $w itemconfig selected -fill red

	} elseif {$creerLien} {
	    lienPTCree $w $a $b
	}}
}


#*******************************---- PLOT DOWN ----***********************************

# ******************* Quand on clique *************************
# plotDown --
# Procedure appelee lorsque on clique sur l'un des cercles
# Arguments:
# w -       La fenetre canvas .
# x, y -    Les coordonnees de la souris (au moment du click).


# ***************** Click sur une place *****************

proc plotDownP {w x y numPlace} {
    global plot
    global detruirePlace
    global tabTransition tpn 
    global tabPlace
    global destroy
    global fin
    global ok
    global newFPT
    global creerLien creerPlace
    global modif
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {

	posDownXY $w $x $y

	if {$detruirePlace == 1} {
	    set modif($tpn) 1
	    supprimerPlace $numPlace
	    redessinerRdP $w
	} elseif {$creerPlace == 2} {
 	    set tabPlace($tpn,$numPlace,jeton) [expr $tabPlace($tpn,$numPlace,jeton)+1]
	    set modif($tpn) 1
	    redessinerRdP $w
	} elseif {$creerLien == 1} {
	    set xa $tabPlace($tpn,$numPlace,xy,x)
	    set ya $tabPlace($tpn,$numPlace,xy,y)
	    set motifFleche [$w create line $xa $ya $x $y -arrow last -tags item]
	    $w addtag newFlechePT withtag $motifFleche
	    set newFPT(place) $numPlace
	} elseif {($creerLien <6)&&($creerLien >0)} {
	    set xa $tabPlace($tpn,$numPlace,xy,x)
	    set ya $tabPlace($tpn,$numPlace,xy,y)
	    
	    
	    set motifCreation [$w create polygon [expr $x] [expr $y -2] \
				[expr $x -2] [expr $y] [expr $x] [expr $y + 2] \
				[expr $x + 2] [expr $y] -width 1 -outline black -fill black]  
	    set motifFleche [$w create line $xa $ya $x $y -arrow last -tags item]
	    $w addtag newFlechePTcreate withtag $motifCreation
	    $w addtag newFlechePT withtag $motifFleche
	    set newFPT(place) $numPlace
	} elseif {$select(vide)} {
	    plotDown $w $x $y
	    $w dtag selected
	    $w addtag selected withtag place($numPlace)
	    $w raise current

	} elseif {![placeDansLaSelection $w $numPlace]} {
	    plotDown $w $x $y
	    redessinerRdP $w
	}
    }
}





proc plotDownFPT {w x y numFleche} {
    global detruireFleche
    global tabTransition tpn
    global tabPlace
    global tabFlechePT
    global destroy
    global fin
    global ok
    global modif
    global creerNoeud
    global maxX
    global maxY
    global plot
    global simulatorOn
    
    if {$simulatorOn==0} {

	set T $tabFlechePT($numFleche,transition)
	set P $tabFlechePT($numFleche,place)
    set type $tabFlechePT($numFleche,type) 
 
	if {$detruireFleche == 1} {
	    set modif($tpn) 1
	    $w delete flechePT($numFleche)
	    supprimerArcPlaceTransition $P $T $type

	} elseif {$creerNoeud==1} {

	    set modif($tpn) 1
	    set xa [posX $w $x]
	    set ya [posY $w $y]
	    ajouterNoeudPT $P $T $type $xa $ya
	}
	redessinerRdP $w
    }
}



proc plotDownFTP {w x y numFleche} {
    global tabFlecheTP
    global detruireFleche
    global tabTransition tpn 
    global destroy
    global fin
    global ok
    global modif
    global creerNoeud
    global maxX
    global maxY
    global plot
    global simulatorOn
    
    if {$simulatorOn==0} {
	
	set T $tabFlecheTP($numFleche,transition)
	set P $tabFlecheTP($numFleche,place)

	# ajouter un noeud dans les arxs ++++++++++++
	if {$creerNoeud==1} {
	    set modif($tpn) 1
	    set xa [posX $w $x]
	    set ya [posY $w $y]
	    ajouterNoeudTP $T $P $xa $ya

	} elseif {$detruireFleche == 1} {

	    $w delete flecheTP($numFleche)
	    set modif($tpn) 1
	    supprimerArcTransitionPlace $T $P
	}
	redessinerRdP $w
    }
}

# ***************** Click sur un noeud *****************

proc plotDownNoeud {w x y numNoeud} {
    global detruireNoeud
    global tabTransition tpn
    global tabPlace
    global tabNoeud
    global destroy
    global fin
    global ok
    global creerLien
    global modif
    global plot
    global maxX maxY
    global select

    global simulatorOn
    
    if {$simulatorOn==0} {

	set modif($tpn) 1

	posDownXY $w $x $y

	if {$detruireNoeud==1} {
	    supprimerNoeud $numNoeud
	    redessinerRdP $w
	} elseif {$select(vide)} {
	    plotDown $w $x $y
	} elseif {![noeudDansLaSelection $w $numNoeud]} {
	    plotDown $w $x $y
	    redessinerRdP $w
	}
    }
}




proc plotDownLabelPlace {w x y numPlace} {
    global plot
    global tabPlace tpn
    global destroy
    global fin
    global ok
    global modif
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {

	posDownXY $w $x $y
	if {$select(vide)} {
	    plotDown $w $x $y
	} elseif {![labelPlaceDansLaSelection $w $numPlace]} {
	    plotDown $w $x $y
	    redessinerRdP $w
	}
    }
}

proc plotDownLabelTransition {w x y numTransition} {
    global plot
    global tabPlace tpn 
    global destroy
    global fin
    global ok
    global modif
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	
	posDownXY $w $x $y
	if {$select(vide)} {
	    plotDown $w $x $y
	} elseif {![labelTransitionDansLaSelection $w $numTransition]} {
	    plotDown $w $x $y
	    redessinerRdP $w
	}
    }
}



proc plotDownT {w x y numTransition} {
    global plot
    global detruireTransition
    global tabTransition tpn 
    global destroy
    global creerLien
    global newFTP
    global modif
    global select
    global simulatorOn
    
    if {$simulatorOn==1} {
	simulatorFireTranstion $w $numTransition
    } else {

	posDownXY $w $x $y

	if {$detruireTransition == 1} {
	    supprimerTransition  $numTransition
	    redessinerRdP $w
	} elseif {$creerLien > 0} {
	    set xa $tabTransition($tpn,$numTransition,xy,x)
	    set ya $tabTransition($tpn,$numTransition,xy,y)

	    set motifFleche [$w create line $xa $ya $x $y -arrow last -tags item]
	    $w addtag newFlecheTP withtag $motifFleche
	    set newFTP(transition) $numTransition

	} elseif {$select(vide)} {
	    plotDown $w $x $y
	} elseif {![transitionDansLaSelection $w $numTransition]} {
	    plotDown $w $x $y
	    redessinerRdP $w
	}    
    }
}

#**************** CLICK DROIT*******************


proc clickDroitFTP {w x y numFleche} {
    global detruireFleche
    global tabTransition
    global tabPlace tpn 
    global tabFlecheTP
    global modif
    global maxX
    global maxY
    global plot zoom

    set T $tabFlecheTP($numFleche,transition)
    set P $tabFlecheTP($numFleche,place)
    set modif($tpn) 1
    set xa [posX $w $x]
    set ya [posY $w $y]
    ajouterNoeudTP $T $P $xa $ya
    redessinerRdP $w
}

proc clickDroitFPT {w x y numFleche} {
    global detruireFleche
    global tabTransition tpn 
    global tabPlace
    global tabFlechePT
    global modif
    global maxX
    global maxY
    global plot

    set T $tabFlechePT($numFleche,transition)
    set P $tabFlechePT($numFleche,place)
    set type $tabFlechePT($numFleche,type) 
    set modif($tpn) 1
    set xa [posX $w $x]
    set ya [posY $w $y]
    ajouterNoeudPT $P $T $type $xa $ya
    redessinerRdP $w
}


proc clickDroitSurCanvas {c x y} {
    global select
    global simulatorOn

    if {($select(red)==0)&&($simulatorOn==0)} {
	destroy $c.add
	menu $c.add -tearoff 0
	$c.add add command -label [mc "Place"] -command "clickNewPlace $c.add $c $x $y"
	$c.add add command -label [mc "Transition"] -command "clickNewTransition $c.add $c $x $y"
	tk_popup $c.add [expr $x+[winfo rootx $c]] [expr $y+[winfo rooty $c]] 0
    }
}

proc clickNewPlace {m c x y} {
    creationPlace $c [posX $c $x] [posY $c $y]
    destroy $m
}

proc clickNewTransition {m c x y} {
    creationTransition $c [posX $c $x] [posY $c $y]
    destroy $m
}




#*******************************************************************************************
# Any enter et Anyleave
#*******************************************************************************************

proc anyLeaveArc {c color} {
    global select
    global simulatorOn
    global tabColor
    
    if {$simulatorOn==0} {
	set select(red) 0
	$c itemconfig current -fill $tabColor(Arc,$color)
    }   
}


proc anyLeaveWeight {c} {
    global select

    set select(red) 0
    $c itemconfig current -fill green4
}


proc anyEnter {c} {
    global select
    global simulatorOn
    if {$simulatorOn==0} {
	set select(red) 1
	$c itemconfig current -fill red
    }
}

proc anyEnterTransition {c i} {
    global select
    global simulatorOn
    set select(red) 1
    if {$simulatorOn==1} {
	if {[firable $i]==1} {$c itemconfig current -fill red}
    } else {
	$c itemconfig current -fill red
    }  
}

proc anyEnterPlace {c i} {
    global select
    global simulatorOn
    if {$simulatorOn==0} {
	set select(red) 1
	$c itemconfig place($i) -fill red
	#  $c lower place($i) jet($i)
	
    }
}


proc anyLeavePlace {c i} {
    global select
    global tabPlace tpn
    global simulatorOn
    global tabColor
    
    set select(red) 0
    if {$simulatorOn==0} {
	if {![placeDansLaSelection $c $i]} {
	    $c itemconfig place($i) -fill $tabColor(Place,$tabPlace($tpn,$i,color))
	}
    }
}

proc anyLeaveNoeud {c i} {
    global select
    global simulatorOn
    global tabColor

    set select(red) 0
    if {$simulatorOn==0} {
	if {![noeudDansLaSelection $c $i]} {
	    $c itemconfig current -fill green
	}
    } 
}

proc anyLeaveLabelPlace {c i} {
    global select

    set select(red) 0
    if {![labelPlaceDansLaSelection $c $i]} {
	$c itemconfig current -fill blue4
    }
}

proc anyLeaveTransition {c i} {
    global select
    global simulatorOn
    global tabTransition tabColor tpn

    set select(red) 0
    if {$simulatorOn==1} {
	if {[firable $i]==1} {set laCouleur green
	} elseif {[enabled $i]==1} {set laCouleur brown
	} else {set laCouleur lightGray}
	$c itemconfig current -fill $laCouleur
    } else {
	if {![transitionDansLaSelection $c $i]} {
	    $c itemconfig current -fill $tabColor(Transition,$tabTransition($tpn,$i,color))
	}
    } 
}

proc anyLeaveLabelTransition {c i} {
    global select

    set select(red) 0
    if {![labelTransitionDansLaSelection $c $i]} {
	$c itemconfig current -fill darkgoldenrod4
    }
}




#*******************************---- PLOT RELEASE ----***********************************
#******************************* Util pour le Dessin des arcs ----***********************************

#+++++++++++++++ validation quand on relache le bouton de la souris

proc releaseNoeud {c x y numNoeud} {
    global tabTransition tpn
    global fin
    global plot
    global modif
    global maxX maxY zoom
    global simulatorOn

    if {$simulatorOn==0} {  
	set modif($tpn) 1
	set xa [expr [posX $c $x]]
	set ya [expr [posY $c $y]]

	if {[noeudDansLaSelection $c $numNoeud]} {
	    deplacerLaSelection $c $x $y
	} else {
	    modifPositionNoeud $xa $ya $numNoeud
	    redessinerRdP $c
	}}
}

proc releasePlace {c x y i} {
    global plot
    global tabPlace tpn
    global maxX
    global maxY
    global select
    global creerLien
    global zoom
    global simulatorOn

    if {$simulatorOn==0} {  

	if {$creerLien} {
	} elseif {[placeDansLaSelection $c $i]} {
	    deplacerLaSelection $c $x $y
	} else {
	    set tabPlace($tpn,$i,xy,x) [expr $tabPlace($tpn,$i,xy,x) + [posX $c $x] - $plot(downX)]
	    set tabPlace($tpn,$i,xy,y) [expr $tabPlace($tpn,$i,xy,y) + [posY $c $y] - $plot(downY)]
	    #       set tabPlace($tpn,$i,xy,x) [posX $c $x]/$zoom
	    #      set tabPlace($tpn,$i,xy,y) [posY $c $y]
	    redessinerRdP $c
	}   }
}

proc releaseLabelPlace {c x y i} {
    global plot
    global tabPlace tpn 
    global maxX
    global maxY
    global select zoom
    global simulatorOn

    if {$simulatorOn==0} {  

	if {[labelPlaceDansLaSelection $c $i]} {
	    deplacerLaSelection $c $x $y
	} else {
	    set tabPlace($tpn,$i,label,dx) [expr $tabPlace($tpn,$i,label,dx) + [posX $c $x] - $plot(downX)]
	    set tabPlace($tpn,$i,label,dy) [expr $tabPlace($tpn,$i,label,dy) + [posY $c $y] - $plot(downY)]
	    #       set tabPlace($tpn,$i,label,dx) [expr [posX $c $x] - $tabPlace($tpn,$i,xy,x)]
	    #       set tabPlace($tpn,$i,label,dy) [expr [posY $c $y] - $tabPlace($tpn,$i,xy,y)]
	    redessinerRdP $c
	}  }
}

proc releaseTransition {c x y i} {
    global plot
    global tabTransition tpn 
    global maxX
    global maxY
    global select
    global creerLien
    global zoom
    global simulatorOn

    if {$simulatorOn==0} {  

	if {$creerLien} {
	} elseif {[transitionDansLaSelection $c $i]} {
	    deplacerLaSelection $c $x $y
	} else {
	    set tabTransition($tpn,$i,xy,x) [expr $tabTransition($tpn,$i,xy,x) + [posX $c $x] - $plot(downX)]
	    set tabTransition($tpn,$i,xy,y) [expr $tabTransition($tpn,$i,xy,y) + [posY $c $y] - $plot(downY)]
	    redessinerRdP $c
	}   }
}

proc releaseLabelTransition {c x y i} {
    global plot
    global tabTransition tpn 
    global maxX
    global maxY
    global select zoom
    global simulatorOn

    if {$simulatorOn==0} {  

	if {[labelTransitionDansLaSelection $c $i]} {
	    deplacerLaSelection $c $x $y
	} else {
	    set tabTransition($tpn,$i,label,dx) [expr $tabTransition($tpn,$i,label,dx) + [posX $c $x] - $plot(downX)]
	    set tabTransition($tpn,$i,label,dy) [expr $tabTransition($tpn,$i,label,dy) + [posY $c $y] - $plot(downY)]
	    redessinerRdP $c
	}   }
}



#*******************************---- PLOT MOVE ----***********************************

# ******************** Quand on bouge la souris ***************************
# plotMove --
# Procedure invoquee pendant le deplacement de la souris (avec selection
# d'un cercle  Elle deplace l'item courant
#
# Arguments:
# w -       La fenetre canvas.
# x, y -    Les coordonnees de la souris.

proc plotMoveNoeud {w x y indice}  {
    global plot
    global maxX maxY
    global modif
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	plotMove $w $x $y
    }
}

proc plotMoveTransition {w x y i} {
    global plot
    global creerLien
    global modif
    global maxX maxY
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	if {$creerLien == 0}  {
	    plotMove $w $x $y
	}
    } 
}


proc plotMovePlace {w x y i} {
    global plot
    global modif tpn
    global creerLien
    global maxX maxY
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	if {$creerLien == 0}  {
	    plotMove $w $x $y
	}}
}

proc plotMoveLabelTransition {w x y i} {
    global plot
    global modif
    global maxX maxY
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	plotMove $w $x $y
    }
}

proc plotMoveLabelPlace {w x y i} {
    global plot
    global modif
    global max maxY
    global select
    global simulatorOn
    
    if {$simulatorOn==0} {
	plotMove $w $x $y
    }
}


#*******************************---- CREATION DES ARCS (lien) ----***********************************


proc creationLien {w x y} {
    global plot
    global tabPlace tpn
    global tabTransition
    global newFPT
    global newFTP
    global creerLien
    global maxX maxY zoom

    # scrolling
    moveX $w $x
    moveY $w $y

    # position exact
    set x [posX $w $x]
    set y [posY $w $y]

    if {$creerLien==1} {

	  if {$newFPT(place)>0 } {

	    $w delete newFlechePT
	    set xa $tabPlace($tpn,$newFPT(place),xy,x)
	    set ya $tabPlace($tpn,$newFPT(place),xy,y)

	    set motifFleche [$w create line $xa $ya $x $y -arrow last -tags item]
	    $w addtag newFlechePT withtag $motifFleche
	    set plot(lastX) $x
	    set plot(lastY) $y
	    $w scale newFlechePT 0 0 $zoom $zoom

	  } elseif {$newFTP(transition)>0 } {

	    $w delete newFlecheTP
	    set xa $tabTransition($tpn,$newFTP(transition),xy,x)
	    set ya $tabTransition($tpn,$newFTP(transition),xy,y)

	    set motifFleche [$w create line $xa $ya $x $y -arrow last -tags item]
	    $w addtag newFlecheTP withtag $motifFleche
	    $w scale newFlecheTP 0 0 $zoom $zoom
	    #    set plot(lastX) $x
	    #    set plot(lastY) $y
	  }
	# si creation d'arc flush ou read ou inhibitor :
    } else {
	if {$newFPT(place)>0 } {

	    $w delete newFlechePT
	    $w delete newFlechePflush
	    set xa $tabPlace($tpn,$newFPT(place),xy,x)
	    set ya $tabPlace($tpn,$newFPT(place),xy,y)
	    set motifFlush [$w create polygon [expr $x] [expr $y -3] \
				[expr $x -3] [expr $y] [expr $x] [expr $y + 3] \
				[expr $x + 3] [expr $y] -width 1 -outline black -fill black]  
	    set motifFleche [$w create line $xa $ya $x $y -tags item]
	    $w addtag newFlechePflush withtag $motifFlush
	    $w addtag newFlechePT withtag $motifFleche
	    set plot(lastX) $x
	    set plot(lastY) $y
	    $w scale newFlechePflush 0 0 $zoom $zoom
	    $w scale newFlechePT 0 0 $zoom $zoom

	} 
	
    }
}


proc lienPTCree {c x y} {
    global tabTransition
    global tabPlace tpn
    global newFPT
    global newFTP
    global fin
    global ok
    global creerLien
    global modif
    global maxX
    global maxY zoom

    set x [posX $c $x]
    set y [posY $c $y]

    if {[expr $creerLien* $newFPT(place)]>0 } {
	set lePlusProche 1000
	set distance 1000

	for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {

	    if {$tabTransition($tpn,$i,statut) == $ok} {
		set x2 $tabTransition($tpn,$i,xy,x)
		set y2 $tabTransition($tpn,$i,xy,y)
		set distance [expr ($x-$x2)*($x-$x2)+($y-$y2)*($y-$y2)]
		if {$distance < $lePlusProche} {
		    set lePlusProche $distance
		    set laTransition $i
		}
	    }
	}
	if {$lePlusProche < 1000} {
	    ajouterArcPlaceTransition $newFPT(place) $laTransition [expr $creerLien -1]
	    set modif($tpn) 1
	}
	set newFPT(place) 0

    }  elseif {[expr $creerLien * $newFTP(transition) ] > 0 } {

	set lePlusProche 1000
	set distance 1000

	for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin}  {incr i} {

	    if {$tabPlace($tpn,$i,statut) == $ok} {
		set x2 $tabPlace($tpn,$i,xy,x)
		set y2 $tabPlace($tpn,$i,xy,y)
		set distance [expr ($x-$x2)*($x-$x2)+($y-$y2)*($y-$y2)]
		if {$distance < $lePlusProche} {
		    set lePlusProche $distance
		    set laPlace $i
		}
	    }
	}
	if {$lePlusProche < 1000} {
	    ajouterArcTransitionPlace $newFTP(transition) $laPlace
	    set modif($tpn) 1
	}
	set newFTP(transition) 0
    }
    redessinerRdP $c
    set plot(lastX) $x
    set plot(lastY) $y
}

#****************************************************************************************************
#****************************** SELECTIONNER COPIER DEPLACER COLLER *********************************
#****************************************************************************************************

#*******************************---- CREATION DES ARCS (lien) ----***********************************


proc creationSelection {w x y} {
    global plot
    global tabPlace tpn
    global tabTransition
    global newFPT
    global newFTP
    global creerLien
    global maxX maxY
    global select zoom
    global simulatorOn
    
    if {$simulatorOn==0} {
	# scrolling
	if {$select(etat)&&!$creerLien} {
	    moveX $w $x
	    moveY $w $y
	    # position exact
	    
	    set select(x2) [posX $w $x]
	    set select(y2) [posY $w $y]

	    $w delete fenetreSelection
	    #     set motifSelection [$w create rect $select(x1) $select(y1) $select(x2) $select(y2) -width 1 -outline black]
	    set motifSelection [$w create rect [posScreenX $w $select(x1)] [posScreenY $w $select(y1)] [posScreenX $w $select(x2)] [posScreenY $w $select(y2)] -width 1 -outline black]
	    $w addtag fenetreSelection withtag $motifSelection
	    #     $w scale fenetreSelection 0 0 $zoom $zoom 
	}}
}



proc placeDansLaSelection {w laPlace} {
    global select
    if {[lsearch $select(listePlace) $laPlace]!=-1} {
	return 1
    } else {
	return 0
    }
}

proc labelPlaceDansLaSelection {w labelPlace} {
    global select
    if {[lsearch $select(listeLabelPlace) $labelPlace]!=-1} {
	return 1
    } else {
	return 0
    }
}

proc noeudDansLaSelection {w leNoeud} {
    global select
    if {[lsearch $select(listeNoeud) $leNoeud]!=-1} {
	return 1
    } else {
	return 0
    }
}


proc transitionDansLaSelection {w laTransition} {
    global select
    if {[lsearch $select(listeTransition) $laTransition]!=-1} {
	return 1
    } else {
	return 0
    }
}

proc labelTransitionDansLaSelection {w labelTransition} {
    global select
    if {[lsearch $select(listeLabelTransition) $labelTransition]!=-1} {
	return 1
    } else {
	return 0
    }
}

#++++++++++++++++++++++indice dans tabNoeud

proc indiceNoeudPT {P T type} {
    global tabTransition tpn
    global tabFlechePT tabFlecheTP tabNoeud
    for {set k 1} {$tabFlechePT($k,transition)>-1} {incr k} {
	if {($tabFlechePT($k,transition)==$T)&&($tabFlechePT($k,place)==$P)&&($tabFlechePT($k,type)==$type)} {
	    for {set kprim 1} {$tabNoeud($kprim,arc)>-1} {incr kprim} {
		if {($tabNoeud($kprim,TP)==-1)&&($tabNoeud($kprim,arc)==$k)} {
		    return $kprim
		}
	    }
	}
    }
    return -1
}

proc indiceNoeudTP {T P} {
    global tabTransition tpn
    global tabFlecheTP tabNoeud
    for {set k 1} {$tabFlecheTP($k,transition)>-1} {incr k} {
	if {($tabFlecheTP($k,transition)==$T)&&($tabFlecheTP($k,place)==$P)} {
	    for {set kprim 1} {$tabNoeud($kprim,arc)>-1} {incr kprim} {
		if {($tabNoeud($kprim,TP)==1)&&($tabNoeud($kprim,arc)==$k)} {
		    return $kprim
		}
	    }
	}
    }
    return -1
}

#++++++++++++++++++++++ Copier coller +++++++++++++++++++++++

proc etablirListe {c liste} {
    global tabPlace tpn 
    global tabTransition tabNoeud
    global fin
    global ok
    global destroy
    global plot
    global select


    set select(vide) 1
    set select(listePlace) [list]
    set select(listeLabelPlace) [list]
    set select(listeTransition) [list]
    set select(listeLabelTransition) [list]
    set select(listeNoeud) [list]


    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$ok} {
	    set element [$c find withtag place($i)]
	    if {[lsearch $liste $element]!=-1} {
		lappend select(listePlace) $i
		set select(vide) 0
	    }
	    set element [$c find withtag labelPlace($i)]
	    if {[lsearch $liste $element]!=-1} {
		lappend select(listeLabelPlace) $i
		set select(vide) 0
	    }
	}
    }
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($tpn,$i,statut) == $ok} {
	    set element [$c find withtag transition($i)]
	    if {[lsearch $liste $element]!=-1} {
		lappend select(listeTransition) $i
		set select(vide) 0
	    }
	    set element [$c find withtag labelTransition($i)]
	    if {[lsearch $liste $element]!=-1} {
		lappend select(listeLabelTransition) $i
		set select(vide) 0
	    }
	}
    }
    for {set i 1} {$tabNoeud($i,arc)>0} {incr i} {
	set element [$c find withtag noeud($i)]
	if {[lsearch $liste $element]!=-1} {
	    lappend select(listeNoeud) $i
	    set select(vide) 0
	}
    }
}

proc recreerSelected {c} {
    global tabPlace tpn 
    global tabTransition tabNoeud
    global fin
    global ok
    global destroy
    global plot
    global select

    $c dtag selected

    for {set i 0} {$i<[llength $select(listePlace)]} {incr i} {
	$c addtag selected withtag place([lindex $select(listePlace) $i])
	$c addtag selected withtag labelPlace([lindex $select(listePlace) $i])
    }
    for {set i 0} {$i<[llength $select(listeNoeud)]} {incr i} {
	$c addtag selected withtag noeud([lindex $select(listeNoeud) $i])
    }
    for {set i 0} {$i<[llength $select(listeTransition)]} {incr i} {
	$c addtag selected withtag transition([lindex $select(listeTransition) $i])
	$c addtag selected withtag labelTransition([lindex $select(listeTransition) $i])
    }
}

proc deplacerLaSelection {c x y} {
    global tabPlace tpn
    global tabTransition
    global fin
    global ok
    global destroy
    global plot
    global select

    set depX [expr [posX $c $x] - $plot(downX)]
    set depY [expr [posY $c $y] - $plot(downY)]
    set select(x1) [expr $select(x1) + $depX]
    set select(x2) [expr $select(x2) + $depX]
    set select(y1) [expr $select(y1) + $depY]
    set select(y2) [expr $select(y2) + $depY]

    for {set i 0} {$i<[llength $select(listePlace)]} {incr i} {
	set laPlace [lindex $select(listePlace) $i]
	set tabPlace($tpn,$laPlace,xy,x) [expr $tabPlace($tpn,$laPlace,xy,x) + $depX]
	set tabPlace($tpn,$laPlace,xy,y) [expr $tabPlace($tpn,$laPlace,xy,y) + $depY]
    }
    for {set i 0} {$i<[llength $select(listeNoeud)]} {incr i} {
	modifRelativePositionNoeud $depX $depY [lindex $select(listeNoeud) $i]
    }
    for {set i 0} {$i<[llength $select(listeTransition)]} {incr i} {
	set laTransition [lindex $select(listeTransition) $i]
	set tabTransition($tpn,$laTransition,xy,x) [expr $tabTransition($tpn,$laTransition,xy,x) + $depX]
	set tabTransition($tpn,$laTransition,xy,y) [expr $tabTransition($tpn,$laTransition,xy,y) + $depY]
    }
    redessinerRdP $c
}

# COLLER :
proc copierLaSelection {c} {
    global tabPlace tpn
    global tabTransition
    global fin
    global ok
    global destroy
    global plot
    global select
    global maxX maxY
    global tempNoeud

    if {[max $select(x1) $select(x2)] > $maxX-8} {set dx -5} else {set dx 5}
    if {[max $select(y1) $select(y2)] > $maxY-8} {set dy -5} else {set dy 5}

    set tempNoeud(1,placeNPT) -1
    set tempNoeud(1,placeNTP) -1
    set tempNoeud(1,transitionNPT) -1
    set tempNoeud(1,transitionNTP) -1
    set tempNoeud(1,type) 0
    
    set select(x1) [expr $select(x1) + $dx]
    set select(x2) [expr $select(x2) + $dx]
    set select(y1) [expr $select(y1) + $dy]
    set select(y2) [expr $select(y2) + $dy]

    set copier(listePlace) $select(listePlace)
    set copier(listeLabelPlace) $select(listeLabelPlace)
    set copier(listeTransition) $select(listeTransition)
    set copier(listeLabelTransition) $select(listeLabelTransition)
    set copier(listeNoeud) $select(listeNoeud)

    set select(listePlace) [list]
    set select(listeLabelPlace) [list]
    set select(listeTransition) [list]
    set select(listeLabelTransition) [list]
    set select(listeNoeud) [list]

    for {set i 0} {$i<[llength $copier(listePlace)]} {incr i} {
	set laPlace [lindex $copier(listePlace) $i]
	set indice [dupliquerPlace $laPlace $dx $dy]
	lappend select(listePlace) $indice
    }

    for {set i 0} {$i<[llength $copier(listeTransition)]} {incr i} {
	set laTransition [lindex $copier(listeTransition) $i]
	set indice [dupliquerTransition $laTransition $copier(listePlace) $select(listePlace) $copier(listeNoeud) $dx $dy]
	lappend select(listeTransition) $indice
    }

    redessinerRdP $c
    for {set npt 1} {$tempNoeud($npt,placeNPT)>-1} {incr npt} {
	lappend select(listeNoeud) [indiceNoeudPT $tempNoeud($npt,placeNPT) $tempNoeud($npt,transitionNPT) $tempNoeud($npt,type)]
    }
    for {set ntp 1} {$tempNoeud($ntp,placeNTP)>-1} {incr ntp} {
	lappend select(listeNoeud) [indiceNoeudTP $tempNoeud($ntp,transitionNTP) $tempNoeud($ntp,placeNTP)]
    }
    redessinerRdP $c
}

proc detruireLaSelection {c} {
    global tabPlace tpn
    global tabTransition
    global fin
    global ok
    global destroy
    global plot
    global select modif
    global maxX maxY

    set modif 1
    set select(vide) 1

    for {set i 0} {$i<[llength $select(listeNoeud)]} {incr i} {
	supprimerNoeud [lindex $select(listeNoeud) $i]
    }
    for {set i 0} {$i<[llength $select(listePlace)]} {incr i} {
	set laPlace [lindex $select(listePlace) $i]
	supprimerPlace $laPlace
    }
    for {set i 0} {$i<[llength $select(listeTransition)]} {incr i} {
	supprimerTransition [lindex $select(listeTransition) $i]
    }
    set select(listePlace) [list]
    set select(listeLabelPlace) [list]
    set select(listeTransition) [list]
    set select(listeLabelTransition) [list]
    set select(listeNoeud) [list]
    redessinerRdP $c
}

#----------------------Couleur-------------------------
proc changerCouleurDeLaSelection {} {
    global tabPlace tpn
    global tabTransition
    global fin
    global ok
    global destroy
    global plot
    global select
    global maxX maxY
    global couleurCourante

  for {set i 0} {$i<[llength $select(listePlace)]} {incr i} {
	set laPlace [lindex $select(listePlace) $i]
	set tabPlace($tpn,$laPlace,color) $couleurCourante(Place)
   } 
   for {set i 0} {$i<[llength $select(listeTransition)]} {incr i} {
     set laTransition [lindex $select(listeTransition) $i]
	 set tabTransition($tpn,$laTransition,color) $couleurCourante(Transition)
    
     for {set j 1} {$tabTransition($tpn,$laTransition,Porg,$j)!=0} {incr j} {
	    set iPo [lsearch $select(listePlace) $tabTransition($tpn,$laTransition,Porg,$j)]
	    if {$iPo!=(-1)} {
	     set tabTransition($tpn,$laTransition,PorgColor,$j) $couleurCourante(Arc)
	    } 
     }

     for {set j 1} {$tabTransition($tpn,$laTransition,Pdes,$j)!=0} {incr j} {
	    set iPo [lsearch $select(listePlace) $tabTransition($tpn,$laTransition,Pdes,$j)]
	    if {$iPo!=-1} {
	     set tabTransition($tpn,$laTransition,PdesColor,$j) $couleurCourante(Arc)
	    } 
     }
   }
}

#***********************************************************


proc max {a b} {
    if {$a >$b} {
	return $a
    } else {
	return $b
    }
}
proc min {a b} {
    if {$a < $b} {
	return $a
    } else {
	return $b
    }
}

proc signe {x} {
    #  if {(($x -$y)>7) || ( ($y - $x)>7 )} {
    #    set resultat [expr ($x+$y)/2]
    #  } elseif {($x -$y)>0} {}
    if {($x)<0} {set resultat -1} else {set resultat 1}

    return $resultat
}

proc moyMax {x y} {
    #  if {(($x -$y)>7) || ( ($y - $x)>7 )} {
    #    set resultat [expr ($x+$y)/2]
    #  } elseif {($x -$y)>0} {}
    if {($x -$y)>0} {
	set resultat [expr ($x+$y)/2 + 5]
    } else {set resultat [expr ($x+$y)/2 - 5]}
    return $resultat
}

