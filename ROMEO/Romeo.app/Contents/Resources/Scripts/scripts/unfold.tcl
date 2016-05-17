#+++++++++++++++++++++ UNFOLDINGUE  +++++++++++++++++++++++++++ 

proc unfolding {option} {
    global tabTransition tpn
    global tabPlace
    global fin
    global ok
    global infini
    global parikhVector

    set taille 140
    for {set indice 1} {$tabTransition($tpn,$indice,statut)!=$fin}  {incr indice} {
        if {$tabTransition($tpn,$indice,statut)==$ok} {
	    if {$tabTransition($tpn,$indice,obs)==1}	{set taille [expr $taille +20] }}
    }
    if {$taille<220} {set taille 220}

    catch {destroy .fenetreParikh}
    toplevel .fenetreParikh
    wm title .fenetreParikh [mc "Parikh vector"]

    frame .fenetreParikh.frame
    set parikh .fenetreParikh.frame
    pack configure $parikh -side left 

    scrollbar  $parikh.scrollv -orient vertical -command "$parikh.canvas yview"
    scrollbar  $parikh.scrollh -orient horizontal -command "$parikh.canvas xview"
    canvas $parikh.canvas -scrollregion "0 0 200 $taille"   -yscrollcommand "$parikh.scrollv set" 	
    pack configure $parikh -side top -expand 1 -fill both
    pack configure  $parikh.scrollv -side right -fill y -expand 1
#    pack configure  $parikh.scrollh -side bottom -fill y -expand 1
#    pack  $parikh.canvas
    pack configure $parikh.canvas
#    scrollbar $parikh.vscroll -command "$parikh.canvas yview"

   # dessin des ascenceurs :

 #   grid $parikh.canvas -in $parikh \
#	-row 0 -column 0 -rowspan 1 -columnspan 1 -sticky news
 #   grid $parikh.vscroll \
#	-row 0 -column 1 -rowspan 1 -columnspan 1 -sticky news
#    grid $w.frame.hscroll \
#	-row 1 -column 0 -rowspan 1 -columnspan 1 -sticky news
 #   grid rowconfig    $parikh 0 -weight 1 -minsize 0
  #  grid columnconfig $parikh 0 -weight 1 -minsize 0


#    pack $parikh.scroll -side right -fill y
#    pack $parikh.canvas -expand yes -fill both
#    frame  $parikh.canvas.vecteur
#    pack $parikh.canvas.vecteur -side left


    # transition par transition
    font configure font1 -family Times -size 14
    set can $parikh.canvas

# D'abord les inobservablse transitions

    set labelTrans [$can create text 10 10 \
                -text "Maximum number of occurences of transitions" \
                -fill black -font font1 -anchor w]

    set labelTrans [$can create text 10 30 \
                -text "1) Unobservable transitions:" \
                -fill blue -font font1 -anchor w]
   
    $can addtag transTitre withtag $labelTrans
   
    set indice 0
    set positionY  60
    $can addtag UnobsTitre withtag $labelTrans
         set labelTrans [$can create text 50 $positionY \
                -text " $parikhVector($tpn,$indice)     - Unobservable transitions"\
                -fill black -font font1 -anchor w]

            $can addtag trans$indice withtag $labelTrans
	    $can bind trans$indice  <Any-Enter> "anyEnterParikh $can"
	    $can bind trans$indice <Any-Leave> "anyLeaveParikh $can"
	    $can bind trans$indice <Double-Button-1> "doubleClickParikh $can $indice $positionY"
            $can bind trans$indice <Button-3> "doubleClickParikh $can $indice $positionY"


   
    $can addtag transTitre2 withtag $labelTrans


    set labelTrans [$can create text 10 [expr $positionY + 30] \
                -text "2) Observable transitions:" \
                -fill blue -font font1 -anchor w]
   
    $can addtag transTitre withtag $labelTrans

    set labelTrans [$can create text 10 [expr $positionY + 50] \
                -text " Observation     -  index -  \" label \" " \
                -fill brown -font font1 -anchor w]
   
    $can addtag transTitre2 withtag $labelTrans

    set positionY 120



    for {set indice 1} {$tabTransition($tpn,$indice,statut)!=$fin}  {incr indice} {
      if {$tabTransition($tpn,$indice,statut)==$ok} {
	if {$tabTransition($tpn,$indice,obs)==1} {
#            set parikhVector($tpn,$indice) 0
            set positionY [expr $positionY+20]

            set labelTrans [$can create text 50 $positionY \
                -text " $parikhVector($tpn,$indice)     -  $indice -  \" $tabTransition($tpn,$indice,label,nom) \" "\
                -fill black -font font1 -anchor w]

            $can addtag trans$indice withtag $labelTrans
	    $can bind trans$indice  <Any-Enter> "anyEnterParikh $can"
	    $can bind trans$indice <Any-Leave> "anyLeaveParikh $can"
	    $can bind trans$indice <Double-Button-1> "doubleClickParikh $can $indice $positionY"
	    $can bind trans$indice <Button-3> "doubleClickParikh $can $indice $positionY"

#            frame  $parikh.canvas.t$indice 
#            pack $parikh.canvas.t$indice  -side top
#            entry $parikh.canvas.t$indice.saisie -justify left -textvariable parikhVector($tpn,$indice) -relief sunken -width 10 -bg white
#            pack $parikh.canvas.t$indice.saisie -side left

#            label $parikh.canvas.t$indice.label 
#            pack $parikh.canvas.t$indice.label -side left
#            $parikh.canvas.t$indice.label config -text "   $indice          \" $tabTransition($tpn,$indice,label,nom) \" "

	 }
      }
    }

    bind .fenetreParikh <Return> "validerUnfolding .fenetreParikh $option"
    bind .fenetreParikh <Escape> "quitterUnfold .fenetreParikh"

    frame .fenetreParikh.buttons -bd 2
    button .fenetreParikh.buttons.annuler -text [mc "Cancel"] -command  "quitterUnfold .fenetreParikh"
    button .fenetreParikh.buttons.accepter -default active -text "Unfold net" \
	-command "validerUnfolding .fenetreParikh $option"
    pack .fenetreParikh.buttons -side bottom -fill both
    pack .fenetreParikh.buttons.accepter .fenetreParikh.buttons.annuler  -side left -expand 1


}

proc anyEnterParikh {c} {
	$c itemconfig current -fill red
}

proc anyLeaveParikh {c} {
	$c itemconfig current -fill black
}

proc validerUnfolding {parikh option} { 
    global cheminTemp plateforme 
    global romeoPath nomRdP tpn tabTransition
    global computOption
    global parikhVector
    global fin ok


       set fichier $nomRdP($tpn)
 
       set executable $romeoPath 
       append executable "bin/mercutio-unf" 

     set yena 0
#     set optionParikh "--parikh=\""
# les unobservables :
     set optionParikh "\(?,$parikhVector($tpn,0)\)"
# les observables :
     for {set indice 1} {$tabTransition($tpn,$indice,statut)!=$fin}  {incr indice} {
       if {$tabTransition($tpn,$indice,statut)==$ok} {
 	 if {$tabTransition($tpn,$indice,obs)==1} {
                set yena 1
		 set optionParikh "$optionParikh\($tabTransition($tpn,$indice,label,nom),$parikhVector($tpn,$indice)\)"
#		 set optionParikh "$optionParikh\($indice,$parikhVector($tpn,$indice)\)"
	 }
       }
     }

       set lefichier "[sansXml $fichier]-parikh.txt"
       set File [open $lefichier w] 
       puts $File "$optionParikh"
       close $File 
       set optionParikh "--parikh $lefichier"
       set optionParikhcourte "--parikh [nomSeul $lefichier]"

       destroy $parikh
     
     
       if {[string compare $plateforme "windows"]} { 
  	 set fileExec $executable 
       } else { 
	 set ext .exe 
	 set fileExec $executable$ext 
       } 

       if {$computOption(event) > 0} {set optionEvent "--max-events=$computOption(event) "} else { set optionEvent ""}
       if {$computOption(depth) > 0} {set optionDepth "--max-depth=$computOption(depth)"} else { set optionDepth ""}

#       set option3 "$option1\  --output=[sansXml $fichier]-unf.xml"
#       set option3courte "$option1 --output=[sansXml [nomSeul $fichier]]-unf.xml"
        if {$option == 1} {set optionP "-p"} else {set optionP ""}

#       set option3 "$option3\ --log=[sansXml $fichier]-unf-log.txt"
#       set option3courte "$option3courte  --log=[sansXml [nomSeul $fichier]]-unf-log.txt"

       if {[file exists $fileExec]} {        
  	 affiche  " -Running: $executable -v $optionEvent $optionDepth $optionP --output=[sansXml [nomSeul $fichier]]-unf.xml --log=[sansXml [nomSeul $fichier]]-unf-log.txt --parikh [nomSeul $lefichier] [nomSeul $fichier] ..."
	 set lepid [exec $executable -v $optionEvent $optionDepth $optionP --output=[sansXml $fichier]-unf.xml --log=[sansXml $fichier]-unf-log.txt --parikh $lefichier $fichier &] 
         affiche "pid = $lepid" 
         afficheBackGround $lepid "[sansXml [nomSeul $fichier]]-unf.xml" 
       }
}



proc quitterUnfold {fp} {
   affiche "\n"
   affiche [mc "-Unfolding window closed"]
   destroy $fp
}


proc doubleClickParikh {parikh indice position} {
    global tabTransition tpn
    global parikhVector
    global nb

    set f .nbObservation
    catch {destroy $f}
    toplevel $f
    wm title $f "Occurence number"

   set nb $parikhVector($tpn,$indice)

    frame $f.saisie -relief ridge -bd 2 -height 2
    entry $f.saisie.entry -justify left -textvariable nb -relief sunken -width 5 -bg white
    label $f.saisie.label
    pack $f.saisie -side top
    pack $f.saisie.entry -side left
    pack $f.saisie.label -side left
    if {$indice>0} {
        $f.saisie.label config -text " $indice          \" $tabTransition($tpn,$indice,label,nom) \""
    } else {
        $f.saisie.label config -text "          \" Unobservable transitions \""
    }
    frame  $f.buttons -bd 2
    button  $f.buttons.annuler -text "Cancel" -command  "destroy $f"
    button  $f.buttons.accepter -default active -text "Ok" \
	-command "validerParikh $parikh $f $indice $position"
    pack  $f.buttons -side bottom -fill both
    pack  $f.buttons.accepter  $f.buttons.annuler  -side left -expand 1

	bind $f <Return> "validerParikh $parikh $f $indice $position"
	bind $f <Escape> "destroy $f"


}

proc validerParikh {parikh fen indice positionY} {
    global tabTransition tpn
    global parikhVector
    global nb

    font configure font1 -family Times -size 14
 
    set parikhVector($tpn,$indice) $nb
    destroy $fen
    $parikh delete trans$indice

    if {$indice>0} {
         set labelTrans [$parikh create text 50 $positionY \
                -text " $parikhVector($tpn,$indice)     -  $indice -  \" $tabTransition($tpn,$indice,label,nom) \" "\
                -fill black -font font1 -anchor w]
    } else {
        set labelTrans [$parikh create text 50 $positionY \
                -text " $parikhVector($tpn,$indice)     -  Unobservable transitions"\
                -fill black -font font1 -anchor w]
    }
    $parikh addtag trans$indice withtag $labelTrans
    $parikh bind trans$indice  <Any-Enter> "anyEnterParikh $parikh"
    $parikh bind trans$indice <Any-Leave> "anyLeaveParikh $parikh"
    $parikh bind trans$indice <Double-Button-1> "doubleClickParikh $parikh $indice $positionY"
    $parikh bind trans$indice <Button-3> "doubleClickParikh $parikh $indice $positionY"
}

proc initParikh {leTpn} {
    global tabTransition tpn
    global fin ok
    global parikhVector

    set parikhVector($tpn,0) 0
    for {set indice 1} {$tabTransition($leTpn,$indice,statut)!=$fin}  {incr indice} {
            set parikhVector($tpn,$indice) 0
    }
}