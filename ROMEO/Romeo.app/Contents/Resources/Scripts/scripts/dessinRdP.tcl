# TODO TYPE   supprimerArcPlaceTransition ajouterNoeudPT ajouterNoeudPT


# la procedure redessiner le rdp
# les procedure associées au différentes actions sur les tags :
#                   release plotDown, plotMove
# sur les places, transitions, fleches, noeuds (coudes)
# le double click est dans maniTPN

# **************** REDESSINER le RDP ***********************

proc redessinerRdP c {

    global tabPlace tpn
    global tabColor
    global tabTransition
    global tabNoeud
    global tabFlechePT
    global tabFlecheTP
    global fin
    global ok
    global destroy
    global nbProcesseur
    global parameters synchronized typePN
    global infini francais
    global select
    global zoom
    global quadrillage
    global simulatorOn
    global dimension
    global deltX
    global deltY
    global xArrow
    global yArrow
    global allowedArc

    set kprim 1
    $c delete all


    if {$simulatorOn==0} {grille $c}

    #tk scaling $c 2

    #taille des éléments
    # rayon des places
    set r $dimension(place)
    # largeur des transitions
    set l $dimension(largeurTransition)
    # hauteur des transitions
    set h $dimension(hauteurTransition)
    # rayon des jetons
    set rj $dimension(jeton)
    # taille du noeud
    set hn $dimension(noeud)
    # taille du flush
    set fl $dimension(flush)
    

    set taillefont [expr int(-12*$zoom)]
    set taillefontPetit [expr int(-9*$zoom)]
    
    font configure font1 -family Times -size $taillefont
    font configure fontPetit -family Times -size $taillefontPetit



    #++++++++++++++++++++++++++ DESSIN DES ARCS  +++++++++++++++++++++++++++++++++++++

    #+++++++++++++++ Fleche Place vers transition +++++++++++++++

    set k 1
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {

	if {$tabTransition($tpn,$i,statut) == $ok} {
      for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} {
	    set laCouleur $tabColor(Arc,$tabTransition($tpn,$i,PorgColor,$j))
	    if {$simulatorOn} {if {[firable $i]} {set laCouleur blue} }

        set arrow 1
        set offset 0
        set typeArcValide 1

        if {$tabTransition($tpn,$i,PorgType,$j)>0} {
		  set arrow 0
		  if {$tabTransition($tpn,$i,PorgType,$j)==3} {set offset 2} 
		  if {$tabTransition($tpn,$i,PorgType,$j)==2} {set offset 1} 
		  if {$tabTransition($tpn,$i,PorgType,$j)==4} {set offset -1} 
		  if {$tabTransition($tpn,$i,PorgType,$j)==1} {set offset -2} 
	          if {(($tabTransition($tpn,$i,PorgType,$j)==1)&&($allowedArc(reset)==0))||(($tabTransition($tpn,$i,PorgType,$j)==2)&&($allowedArc(read)==0))||(($tabTransition($tpn,$i,PorgType,$j)==3)&&($allowedArc(logicInhibitor)==0))||(($tabTransition($tpn,$i,PorgType,$j)==4)&&($allowedArc(timedInhibitor)==0))} {
		      set typeArcValide 0 
                  }
        }
	  if {$typeArcValide} {
        
		if {$tabTransition($tpn,$i,PorgNailx,$j)+$tabTransition($tpn,$i,PorgNaily,$j)==0} {

		   set xa $tabPlace($tpn,$tabTransition($tpn,$i,Porg,$j),xy,x)
		   set ya $tabPlace($tpn,$tabTransition($tpn,$i,Porg,$j),xy,y)
		   set xb $tabTransition($tpn,$i,xy,x)
		   set yb $tabTransition($tpn,$i,xy,y)

		   set motifFleche [faireUnArcPT $c $xa $ya $xb $yb $laCouleur $arrow $offset]
                   set xWeight [moyMax $xa $xb] 
                   set yWeight [moyMax $yb $ya]
		  
		} else {
		    set xa $tabPlace($tpn,$tabTransition($tpn,$i,Porg,$j),xy,x)
		    set ya $tabPlace($tpn,$tabTransition($tpn,$i,Porg,$j),xy,y)
		    set xb $tabTransition($tpn,$i,PorgNailx,$j)
		    set yb $tabTransition($tpn,$i,PorgNaily,$j)
		    set xc $tabTransition($tpn,$i,xy,x)
		    set yc $tabTransition($tpn,$i,xy,y)
  
  		    set motifFleche [faireUnArcPnT $c $xa $ya $xb $yb $xc $yc $laCouleur $arrow $offset]
		    
		    # puis on met le noeud
		    set motifNoeud [$c create rect [expr $xb-$hn] [expr $yb-$hn] \
					[expr $xb+$hn] [expr $yb+$hn] -width 1 -outline black \
					-fill green]

		    $c addtag noeud($kprim) withtag $motifNoeud

		    $c bind noeud($kprim) <Any-Enter> "anyEnter $c"
		    $c bind noeud($kprim) <Any-Leave> "anyLeaveNoeud $c $kprim"
		    $c bind noeud($kprim) <1> "plotDownNoeud $c %x %y $kprim"
		    $c bind noeud($kprim) <ButtonRelease-1> "releaseNoeud $c %x %y $kprim"
		    $c bind noeud($kprim) <B1-Motion> "plotMoveNoeud $c %x %y $kprim"

		    set tabNoeud($kprim,TP) -1
		    set tabNoeud($kprim,arc) $k

		    # pour placer le weight on fait le changement :
		    #y = ax+b avec a = ($yc-$ya)/($xc-$xa) b pour ($xc,$yc)
		    #on cherche si b est au dessus de la droite passant par a et c

  	            if {$xc==$xa} {
		       set coef [signe [expr $yb-((($yc-$ya)/(0.001))*($xb-$xc)+$yc)]]
                    } else {
                        set coef [signe [expr $yb-((($yc-$ya)/($xc-$xa))*($xb-$xc)+$yc)]]
                    }

   		    set xWeight [expr $xb-$coef*7]  
		    set yWeight [expr $yb+$coef*5]
		    incr kprim
		}


		# pour tous les arcs PT (avec ou sans noeud) avec ou sans flush :

#+++++++++++++DESSIN DU FLUSH READ INHIBITOR++++++++++++++++++++++++++++++++++++++
		
            if {$tabTransition($tpn,$i,PorgType,$j)==1} {
			 set motifFlush [$c create polygon [expr $xArrow + $fl] $yArrow \
					    [expr $xArrow] [expr $yArrow + $fl] [expr $xArrow - $fl] [expr $yArrow] \
					    [expr $xArrow] [expr $yArrow - $fl] -width 1 -outline black -fill black]  
			 $c addtag flush($i,$j) withtag $motifFlush   
             } elseif {$tabTransition($tpn,$i,PorgType,$j)==2} {
			 set motifRead [$c create polygon [expr $xArrow - $fl] [expr $yArrow - $fl] \
					    [expr $xArrow  + $fl] [expr $yArrow - $fl] [expr $xArrow + $fl] [expr $yArrow + $fl] \
					    [expr $xArrow - $fl] [expr $yArrow + $fl]  -width 1 -outline black -fill lightgray]  
			 $c addtag readArc($i,$j) withtag $motifRead   
             } elseif {$tabTransition($tpn,$i,PorgType,$j)==3} {
			 set motifLogicInhib [$c create oval [expr $xArrow - $fl] [expr $yArrow - $fl] [expr $xArrow + $fl] [expr $yArrow + $fl] -width .5 -outline black -fill orange]  
			 $c addtag logicInhib($i,$j) withtag $motifLogicInhib   
             } elseif {$tabTransition($tpn,$i,PorgType,$j)==4} {
			 set motifTimedInhib [$c create oval [expr $xArrow - $fl] [expr $yArrow - $fl] [expr $xArrow + $fl] [expr $yArrow + $fl] -width 2 -outline black -fill white]  
			 $c addtag timedInhib($i,$j) withtag $motifTimedInhib   
            }


		$c addtag flechePT($k) withtag $motifFleche
		set tabFlechePT($k,place) $tabTransition($tpn,$i,Porg,$j)
		set tabFlechePT($k,transition) $i
		set tabFlechePT($k,type) $tabTransition($tpn,$i,PorgType,$j)

		$c bind flechePT($k)  <Any-Enter> "anyEnter $c"
		$c bind flechePT($k) <Any-Leave> "anyLeaveArc $c $tabTransition($tpn,$i,PorgColor,$j)"
		$c bind flechePT($k) <1> "plotDownFPT $c %x %y $k"
		$c bind flechePT($k) <Button-3> "clickDroitFPT $c %x %y $k"
		$c bind flechePT($k) <Button-2> "doubleClickFPT $c $k"
		$c bind flechePT($k) <Double-Button-1> "doubleClickFPT $c $k"

		if {$tabTransition($tpn,$i,PorgWeight,$j)!=1} {
		    set motifWeight [$c create text $xWeight $yWeight \
					 -text $tabTransition($tpn,$i,PorgWeight,$j) -fill green4 -font font1 -anchor center]
		    $c addtag labelPTWeight($k) withtag $motifWeight
		    $c bind labelPTWeight($k)  <Any-Enter> "anyEnter $c"
		    $c bind labelPTWeight($k) <Any-Leave> "anyLeaveWeight $c"
		    $c bind labelPTWeight($k) <Double-Button-1> "doubleClickFPT $c $k"
		    $c bind labelPTWeight($k) <Button-3> "doubleClickFPT $c $k"
		}

		incr k

	    }
	}
	}
    }
    set tabFlechePT($k,transition) -1
    set tabFlechePT($k,place) -1
    set tabFlechePT($k,type) 0


    #+++++++++++++++ Fleche transition vers place +++++++++++++++

    set k 1
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {

	if {$tabTransition($tpn,$i,statut) == $ok} {
      for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} {
	    set laCouleur $tabColor(Arc,$tabTransition($tpn,$i,PdesColor,$j))
	    if {$simulatorOn} {if {[firable $i]} {set laCouleur brown} }
		if {$tabTransition($tpn,$i,PdesNailx,$j)+$tabTransition($tpn,$i,PdesNaily,$j)==0} {
		    set xa $tabTransition($tpn,$i,xy,x)
		    set ya $tabTransition($tpn,$i,xy,y)
		    set xb $tabPlace($tpn,$tabTransition($tpn,$i,Pdes,$j),xy,x)
		    set yb $tabPlace($tpn,$tabTransition($tpn,$i,Pdes,$j),xy,y)

  		    set arrow -1
		    set motifFleche [faireUnArcPT $c $xb $yb $xa $ya $laCouleur $arrow 0]
		    set xWeight [moyMax $xa $xb] 
		    set yWeight [moyMax $yb $ya]
		} else {
		    set xc $tabPlace($tpn,$tabTransition($tpn,$i,Pdes,$j),xy,x)
		    set yc $tabPlace($tpn,$tabTransition($tpn,$i,Pdes,$j),xy,y)
		    set xb $tabTransition($tpn,$i,PdesNailx,$j)
		    set yb $tabTransition($tpn,$i,PdesNaily,$j)
		    set xa $tabTransition($tpn,$i,xy,x)
		    set ya $tabTransition($tpn,$i,xy,y)

  		    set arrow -1
 		    set motifFleche [faireUnArcPnT $c $xc $yc $xb $yb $xa $ya $laCouleur $arrow 0]

		    # puis on met le noeud
		    set motifNoeud [$c create rect [expr $xb-$hn] [expr $yb-$hn] \
					[expr $xb+$hn] [expr $yb+$hn] -width 1 -outline black \
					-fill green]
		    $c addtag noeud($kprim) withtag $motifNoeud
		    $c bind noeud($kprim) <Any-Enter> "anyEnter $c"
		    $c bind noeud($kprim) <Any-Leave> "anyLeaveNoeud $c $kprim"
		    $c bind noeud($kprim) <ButtonRelease-1> "releaseNoeud $c %x %y $kprim"
		    $c bind noeud($kprim) <1> "plotDownNoeud $c %x %y $kprim"
		    $c bind noeud($kprim) <B1-Motion> "plotMoveNoeud $c %x %y $kprim"
		    set tabNoeud($kprim,TP) 1
		    set tabNoeud($kprim,arc) $k

		    incr kprim

		    # pour placer le weight on fait le changement :
		    #y = ax+b avec a = ($yc-$ya)/($xc-$xa) b pour ($xc,$yc)
		    #on cherche si b est au dessus de la droite passant par a et c

  	        if {$xc==$xa} {
		       set coef [signe [expr $yb-((($yc-$ya)/(0.001))*($xb-$xc)+$yc)]]
            } else {
               set coef [signe [expr $yb-((($yc-$ya)/($xc-$xa))*($xb-$xc)+$yc)]]
            }

   		    set xWeight [expr $xb-$coef*7]  
		    set yWeight [expr $yb+$coef*5]

		}

		# pour tous les arcs PT (avec ou sans noeud) :

		$c addtag flecheTP($k) withtag $motifFleche
		set tabFlecheTP($k,place) $tabTransition($tpn,$i,Pdes,$j)
		set tabFlecheTP($k,transition) $i
		$c bind flecheTP($k)  <Any-Enter> "anyEnter $c"
		$c bind flecheTP($k) <Any-Leave> "anyLeaveArc $c $tabTransition($tpn,$i,PdesColor,$j)"
		$c bind flecheTP($k) <1> "plotDownFTP $c %x %y $k"
		$c bind flecheTP($k) <Button-3> "clickDroitFTP $c %x %y $k"
		$c bind flecheTP($k) <Button-2> "doubleClickFTP $c $k"
		$c bind flecheTP($k) <Double-Button-1> "doubleClickFTP $c $k"

		if {$tabTransition($tpn,$i,PdesWeight,$j)!=1} {
		    set motifWeight [$c create text $xWeight $yWeight \
					 -text $tabTransition($tpn,$i,PdesWeight,$j) -fill green4 -font font1 -anchor center]
		    $c addtag labelTPWeight($k) withtag $motifWeight
		    $c bind labelTPWeight($k)  <Any-Enter> "anyEnter $c"
		    $c bind labelTPWeight($k) <Any-Leave> "anyLeaveWeight $c"
		    $c bind labelTPWeight($k) <Double-Button-1> "doubleClickFTP $c $k"
		    $c bind labelTPWeight($k) <Button-3> "doubleClickFTP $c $k"
		}

		incr k

	    }
	}
    }
    set tabNoeud($kprim,arc) -1
    set tabFlecheTP($k,transition) -1
    set tabFlecheTP($k,place) -1



    #++++++++++++++++++++++++++ DESSIN DES PLACES  +++++++++++++++++++++++++++++++++++++

    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$ok} {
	    set x $tabPlace($tpn,$i,xy,x)
	    set y $tabPlace($tpn,$i,xy,y)

	    if {$simulatorOn==0} {set laCouleur $tabColor(Place,$tabPlace($tpn,$i,color)) 
	    } elseif {$tabPlace($tpn,$i,jeton)==0} { set laCouleur lightGray} else {set laCouleur yellow}
	    
	    set motifPlace [$c create oval [expr $x-$r] [expr $y-$r] \
				[expr $x+$r] [expr $y+$r] -width 1 -outline black \
				-fill $laCouleur]

	    $c addtag place($i) withtag $motifPlace 

	    $c bind place($i) <Any-Enter> "anyEnterPlace $c $i"
	    $c bind place($i) <Any-Leave> "anyLeavePlace $c $i"
	    $c bind place($i) <1> "plotDownP $c %x %y $i"
	    $c bind place($i) <Double-Button-1> "doubleClickP $c $i"
	    $c bind place($i) <Button-3> "doubleClickP $c $i"
	    $c bind place($i) <Button-2> "doubleClickP $c $i"
	    $c bind place($i) <ButtonRelease-1> "releasePlace $c %x %y $i"
	    $c bind place($i) <B1-Motion> "plotMovePlace $c %x %y $i"

	    
	    if {$tabPlace($tpn,$i,jeton)>0} {
		set motifJeton [$c create oval [expr $x-$rj+3] [expr $y-$rj] \
				    [expr $x+$rj+3] [expr $y+$rj] -width 1  -outline black \
				    -fill black]
		set texteJeton [$c create text $x $y -text $tabPlace($tpn,$i,jeton) -fill black -font fontPetit -anchor e]
		$c addtag jet($i) withtag $motifJeton 
		$c addtag jet($i) withtag $texteJeton 
		
		$c bind jet($i) <Any-Enter> "anyEnterPlace $c $i"
		$c bind jet($i) <Any-Leave> "anyLeavePlace $c $i"
		$c bind jet($i) <1> "plotDownP $c %x %y $i"
		$c bind jet($i) <Double-Button-1> "doubleClickP $c $i"
		$c bind jet($i) <Button-3> "doubleClickP $c $i"
		$c bind jet($i) <Button-2> "doubleClickP $c $i"
		$c bind jet($i) <ButtonRelease-1> "releasePlace $c %x %y $i"
		$c bind jet($i) <B1-Motion> "plotMovePlace $c %x %y $i"
	    }  
	    
	    # creation du tag label Place
	    if {$tabPlace($tpn,$i,processeur)>$nbProcesseur($tpn)} {set tabPlace($tpn,$i,processeur) 0}
	    if {($tabPlace($tpn,$i,processeur)>0)&&($typePN==-2)} {
		set leTexte "$tabPlace($tpn,$i,label,nom) \n Proc. $tabPlace($tpn,$i,processeur) \n Prio. $tabPlace($tpn,$i,priorite)"
	    } else {
		if {($typePN==2)&&(!(($tabPlace($tpn,$i,dmin)==0) && ($tabPlace($tpn,$i,dmax)== $infini)))} {
		    if {$tabPlace($tpn,$i,dmax) < $infini} {
			set finInterval "$tabPlace($tpn,$i,dmax) \]"
		    } else {
			set finInterval "inf \["
		    }
		    set leTexte "$tabPlace($tpn,$i,label,nom) \n \[ $tabPlace($tpn,$i,dmin); $finInterval"
		 } else { set leTexte $tabPlace($tpn,$i,label,nom) }
	    }

	    set motifLabel [$c create text [expr $x+$tabPlace($tpn,$i,label,dx)] \
				[expr $y+$tabPlace($tpn,$i,label,dy)] -text $leTexte -fill blue4 -font font1 -anchor n]
	    $c addtag labelPlace($i) withtag $motifLabel
	    $c bind labelPlace($i) <Any-Enter> "anyEnter $c"
	    $c bind labelPlace($i) <Any-Leave> "anyLeaveLabelPlace $c $i"
	    $c bind labelPlace($i) <1> "plotDownLabelPlace $c %x %y $i"
	    $c bind labelPlace($i) <ButtonRelease-1> "releaseLabelPlace $c %x %y $i"
	    $c bind labelPlace($i) <B1-Motion> "plotMoveLabelPlace $c %x %y $i"


	}
    }

    #++++++++++++++++++++++++++ DESSIN DES TRANSITIONS  ++++++++++++++++++++++++++++++++

    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
	if {$tabTransition($tpn,$i,statut) == $ok} {
	    set x $tabTransition($tpn,$i,xy,x)
	    set y $tabTransition($tpn,$i,xy,y)
	    
	    if {[isSynchronized $i]} { 
		set epaisseur 3
	    } else { 
		set epaisseur 1
	    }
	    if {$simulatorOn==0} {set laCouleur $tabColor(Transition,$tabTransition($tpn,$i,color))  
	    } elseif {[firable $i]==1} {set laCouleur green} elseif {[enabled $i]==1} {set laCouleur brown} else {set laCouleur lightGray}
	    
	    set motifTransition [$c create rect [expr $x-$l] [expr $y-$h] \
				     [expr $x+$l] [expr $y+$h] -width $epaisseur -outline black \
				     -fill $laCouleur]

	    $c addtag transition($i) withtag $motifTransition

	    $c bind transition($i) <Any-Enter> "anyEnterTransition  $c $i"
	    $c bind transition($i) <Any-Leave> "anyLeaveTransition $c $i"
	    $c bind transition($i) <1> "plotDownT $c %x %y $i"
	    $c bind transition($i) <Double-Button-1> "doubleClickT $c $i"
	    $c bind transition($i) <Button-2> "doubleClickT $c $i"
	    $c bind transition($i) <Button-3> "doubleClickT $c $i"
	    $c bind transition($i) <ButtonRelease-1> "releaseTransition $c %x %y $i"
	    $c bind transition($i) <B1-Motion> "plotMoveTransition $c %x %y $i"

	    # creation du tag label transition
	    if {$parameters>=1} {
		if {$tabTransition($tpn,$i,minparam)!= ""} {
			set min $tabTransition($tpn,$i,minparam)
                } else {set min 0}
		if {$tabTransition($tpn,$i,maxparam)!= ""} {
			set finInterval "$tabTransition($tpn,$i,maxparam) \]"
	 	if {![string compare $tabTransition($tpn,$i,maxparam) "infinity"]} {set finInterval  "inf \["}
                } else { set finInterval  "inf \["}

		set debutInterval "\[ $min;"

	 	if {($min == 0) && (![string compare $finInterval "inf \[" ])} {
                   set leTexte "$tabTransition($tpn,$i,label,nom)"
                } else {
 		   set leTexte "$tabTransition($tpn,$i,label,nom) \n $debutInterval $finInterval"
                }

	    } else {

		if {($typePN!=2)&&(!(($tabTransition($tpn,$i,dmin)==0) && ($tabTransition($tpn,$i,dmax)== $infini)))} {
			if {$tabTransition($tpn,$i,dmax) < $infini} {
			set finInterval "$tabTransition($tpn,$i,dmax) \]"
			} else {
				set finInterval "inf \["
			}
			set leTexte "$tabTransition($tpn,$i,label,nom) \n \[ $tabTransition($tpn,$i,dmin); $finInterval"
		} else { set leTexte $tabTransition($tpn,$i,label,nom) }
	    }
	    set motifLabel [$c create text  [expr $x+$tabTransition($tpn,$i,label,dx)] \
				[expr $y+$tabTransition($tpn,$i,label,dy)] -text $leTexte -fill darkgoldenrod4 -font font1 -anchor n]
	    $c addtag labelTransition($i) withtag $motifLabel
	    $c bind labelTransition($i) <Any-Enter> "anyEnter $c"
	    $c bind labelTransition($i) <Any-Leave> "anyLeaveLabelTransition $c $i"
	    $c bind labelTransition($i) <1> "plotDownLabelTransition $c %x %y $i"
	    $c bind labelTransition($i) <ButtonRelease-1> "releaseLabelTransition $c %x %y $i"
	    $c bind labelTransition($i) <B1-Motion> "plotMoveLabelTransition $c %x %y $i"

	}
    }


    recreerSelected $c
    $c itemconfig selected -fill red
    $c scale all 0 0 $zoom $zoom 

    set font2 {Helvetica 4 bold}


    # fin de redessiner rdp
}

#*******************************************************************************************
# DESSIN DES ARCS (courbe de Bezier ....)
#*******************************************************************************************

#Dessine un arc entre une place A(xa,ya) et une transition B(xb,yb) orientée -1 0 ou 1

proc faireUnArcPT {c xa ya xb yb laCouleur arrow offset} {
    global dimension
    global xArrow
    global yArrow

		    set offsetX 0
		    set offsetY 0

            set r $dimension(place)
            set l $dimension(largeurTransition)
            set h $dimension(hauteurTransition)
            set fl $dimension(flush)

	# il faut maintenant retirer  a/sqrt(a*a+b*b) pour partir du cercle :
		    # le rayon du cercle est $r (8)
		    set hypo [expr hypot($xb-$xa, [expr $yb-$ya])]
		    if {$hypo==0} {set hypo 1}
		    set rx [expr ($xb-$xa)*$r/$hypo]
		    set ry [expr ($yb-$ya)*$r/$hypo]
		    set xa [expr $xa+$rx]
		    set ya [expr $ya+$ry]

		    # pour partir du bord de la transition
		    set den [expr $xa-$xb]
		    if {$den==0} {set den 1}
		    # delX et deltY pour faire le flush et les inhibitor....
		    set deltX -1
		    set deltY -1
		    if {[expr abs(($ya-$yb)/($den))]<0.3} {
 		      set offsetY $offset
			  if {$yb>$ya} { set deltY -1} else { set deltY 1}
			  if {$xb>$xa} { 
			    set xb [expr $xb-$l] 
			    set deltX -1
			  } else { 
			    set xb [expr $xb+$l] 
			    set deltX 1
			  }
		    } else {
		      set offsetX $offset
			  if {$xb>$xa} { set deltX -2} else { set deltX 2}
			  if {$yb>$ya} { 
			    set yb [expr $yb-$h] 
			    set deltY -1
			  } else { 
			    set yb [expr $yb+$h] 
			    set deltY 1
			  }
		    }
		    if {$arrow==0} {
		       set xArrow [expr $xb + $fl*$deltX + $offsetX*$deltX] 
			   set yArrow [expr $yb + $fl*$deltY + $offsetY*$deltY] 
			   set leMotifFleche [$c create line $xa $ya $xArrow $yArrow -tags item -fill $laCouleur]
		    } elseif {$arrow==-1} {
			   set leMotifFleche [$c create line $xa $ya $xb $yb -arrow first -tags item -fill $laCouleur]
		    } else {
			   set leMotifFleche [$c create line $xa $ya $xb $yb -arrow last -tags item -fill $laCouleur]
		    }
            return $leMotifFleche
}		    


proc faireUnArcPnT {c xa ya xb yb xc yc laCouleur arrow offset} {
    global dimension
    global xArrow
    global yArrow

           set r $dimension(place)
           set l $dimension(largeurTransition)
           set h $dimension(hauteurTransition)
           set fl $dimension(flush)


		    set offsetX 0
		    set offsetY 0
		    # il faut maintenant retirer  a/sqrt(a*a+b*b) pour partir du bord du cercle :
		    # le rayon du cercle est $r (8 pour zoom = 1)
		    set hypo [expr hypot($xb-$xa, [expr $yb-$ya])]
		    if {$hypo==0} {set hypo 1}
		    set rx [expr ($xa-$xb)*8/$hypo]
		    set ry [expr ($ya-$yb)*8/$hypo]
		    set xa [expr $xa-$rx]
		    set ya [expr $ya-$ry]
		    # pour partir du bord de la transition
		    set den [expr $xc-$xb]
		    set deltX -1
		    set deltY -1
		    if {$den==0} {set den 1}
		    if {[expr abs(($yc-$yb)/($den))]<0.3} {
		      set offsetY $offset
			  if {$yc>$yb} { set deltY -1} else { set deltY 1}
			  if {$xc>$xb} { 
			    set xc [expr $xc-$l] 
			    set deltX -1
			  } else { 
			    set xc [expr $xc+$l] 
			    set deltX 1
			  }
		    } else {
		      set offsetX $offset
			  if {$xc>$xb} { set deltX -2} else { set deltX 2}
			  if {$yc>$yb} { 
			    set yc [expr $yc-$h] 
			    set deltY -1
			  } else { 
			    set yc [expr $yc+$h] 
			    set deltY 1
			  }
		    }

		    # courbe de Bezier passant par B (approx) [expr (2*$xb-($xa+$xc)/2)] [expr (2*$yb-($ya+$yc)/2)]

		    if {$arrow==0} {
		       set xArrow [expr $xc + $fl*$deltX + $offsetX*$deltX] 
			   set yArrow [expr $yc + $fl*$deltY + $offsetY*$deltY] 
 			   set leMotifFleche [$c create line $xa $ya [expr (2*$xb-($xa+$xArrow)/2)] [expr (2*$yb-($ya+$yArrow)/2)] $xArrow $yArrow  -smooth 1 -tags item -fill $laCouleur]
		    } elseif {$arrow==-1} {
 			   set leMotifFleche [$c create line $xa $ya [expr (2*$xb-($xa+$xc)/2)] [expr (2*$yb-($ya+$yc)/2)] $xc $yc  -smooth 1 -arrow first -tags item -fill $laCouleur]
		    } else {
 			   set leMotifFleche [$c create line $xa $ya [expr (2*$xb-($xa+$xc)/2)] [expr (2*$yb-($ya+$yc)/2)] $xc $yc  -smooth 1 -arrow last -tags item -fill $laCouleur]
		    }
            return $leMotifFleche
}		    


