#procedures  Control Panel et associées
#*
#*********


proc controlPanel {w c} {
    global nomRdP
    global francais
    global infini
    global parameters allowedArc outFormat computOption typePN
    global simulatorOn
    global tabPlace tabJeton ok fin tpn
    global ancienAllowedArc ancienMode
    global firstTime
    global nb
    global nbProcesseur
    global modif 


# met a disable le bouton control panel de la barre du haut    
#    destroy $w.barreHaut.d.control
#    button $w.barreHaut.d.control -text [mc "Control Panel"] -command "controlPanel $w $c"  -state disabled
#    pack $w.barreHaut.d.control -side right -padx 5
    
    # ++++++++++++++++ Creation de la fenetre d'affichage ++++++++++++++++++
    catch {destroy .control}
    toplevel .control
    wm title .control [mc "Control panel"]
    wm protocol .control WM_DELETE_WINDOW {disableControl .romeo.global .romeo.global.frame.c}

#	set x [expr [winfo x .romeo]+[winfo width .romeo]]
	set y [expr [winfo y .romeo]]
#	wm geometry .control +$x+$y

	wm geometry .control +0+$y
if {$firstTime(control)} {
	wm geometry .romeo +155+$y
	set firstTime(control) 0
}

#pour ne pas avoir les 3 boutons en haut
#	wm overrideredirect .control on

    frame .control.frame -width 135
    set s .control.frame 
    pack $s -side right -pady 2m -padx 10
#    frame $s.marge
#    pack $s.marge -side top -pady 20
#    label $s.titre -text [mc "Control Panel"]
#    pack $s.titre -side top -pady 4
    
    # type de TPN
#    set ancienMode(scheduling) $scheduling 
    set ancienMode(parameters) $parameters
    set ancienMode(typePN) $typePN
#    set ancienMode(hull) $computOption(hull)

    frame $s.optionTPN -relief solid -bd 1
    label $s.optionTPN.label
    pack $s.optionTPN.label -side top -pady 2 -anchor w
    $s.optionTPN.label config -text [mc "Petri net extension:"]
    pack $s.optionTPN -side top -fill x
    radiobutton $s.optionTPN.ttpn -text "Time (T-TPN)" -variable typePN -value 1 -selectcolor red -command "validControl $w $c"
# deb P-TPN ---------------
#    radiobutton $s.optionTPN.ptpn -text "Time (P-TPN)" -variable typePN -value 2 -selectcolor red -command "validControl $w $c"
# fin P-TPN ---------------
    radiobutton $s.optionTPN.stopwatch -text "Stopwatch-T-TPN -> timed inhibitor arcs" -variable typePN -value -1  -selectcolor red -command "validControl $w $c"
    radiobutton $s.optionTPN.schedule -text [mc "Scheduling-T-TPN"] -variable typePN -value -2  -selectcolor red -command "validControl $w $c"

    pack $s.optionTPN.ttpn -side top -pady 2 -anchor w
# deb P-TPN ---------------
#    pack $s.optionTPN.ptpn -side top -pady 2 -anchor w
# fin P-TPN ---------------
    pack $s.optionTPN.stopwatch -side top -pady 2 -anchor w
    pack $s.optionTPN.schedule -side top -pady 2 -anchor w

 # Definition et choix du scheduler

#    frame $s.fenetreScheduler -relief solid -bd 1
#    pack $s.fenetreScheduler -side top -pady 2 -anchor w -fill x  

    if {$typePN ==-2} {
      button $s.optionTPN.define -state active -text [mc "Define scheduler..."]  -command "definirProcesseur $c"
    } else {
      button $s.optionTPN.define -state disabled -text [mc "Define scheduler..."]  -command "definirProcesseur $c"
    }
    pack $s.optionTPN.define  -side left -expand 1

# parameters
    frame $s.parametre -relief solid -bd 1
    pack $s.parametre -side top -pady 2 -anchor w -fill x
    label $s.parametre.label
    pack $s.parametre.label -side top -pady 2 -anchor w
    $s.parametre.label config -text [mc "Parameters:"]

    radiobutton $s.parametre.paramNo -text "No" -variable parameters -value 0 -selectcolor red -command "validParametre $w $c"
    radiobutton $s.parametre.paramYes -text "Real parameters" -variable parameters -value 1 -selectcolor red -command "validParametre $w $c"
    radiobutton $s.parametre.paramInt -text "Integer parameters" -variable parameters -value 2 -selectcolor red -command "validParametre $w $c"

    pack $s.parametre.paramNo -side top -pady 2 -anchor w
    pack $s.parametre.paramYes -side top -pady 2 -anchor w
    pack $s.parametre.paramInt -side top -pady 2 -anchor w


# parameters Integer Hull
#    frame $s.parametre.integer
#    pack $s.parametre.integer -side top -pady 2 -anchor w -fill x
#    label $s.parametre.integer.marge
#    $s.parametre.integer.marge config -text "      "
#    pack $s.parametre.integer.marge -side left -pady 2 -anchor w
#    frame $s.parametre.integer.hull 
#    pack $s.parametre.integer.hull -side top -pady 2 -anchor w -fill x
#    radiobutton $s.parametre.integer.hull.full -text "full integer hull" -variable computOption(hull) -value 2 -selectcolor red -command "validParametre $w $c"
#    radiobutton $s.parametre.integer.hull.nofull -text "integer hull only on parameters" -variable computOption(hull) -value 1 -selectcolor red -command "validParametre $w $c"

#    pack $s.parametre.integer.hull.full -side top -pady 2 -anchor w
#    pack $s.parametre.integer.hull.nofull -side top -pady 2 -anchor w

#    if {$parameters < 2} { 
#    	$s.parametre.integer.hull.nofull configure -state disabled
#    	$s.parametre.integer.hull.full configure -state disabled
#    }

    # typePN : -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn
    if {($typePN == 2)||($typePN==-2)} { 
	$s.parametre.paramNo configure -state disabled
    	$s.parametre.paramYes configure -state disabled
        $s.parametre.paramInt configure -state disabled

#    	$s.parametre.integer.hull.nofull configure -state disabled
#    	$s.parametre.integer.hull.full configure -state disabled
    }

    # type d'arc
    
    frame $s.arc -relief solid -bd 1
    pack $s.arc -side top -pady 2 -anchor w -fill x
    label $s.arc.label
    pack $s.arc.label -side top -pady 2 -anchor w
    $s.arc.label config -text [mc "Logical arcs:"]
    set ancienAllowedArc(reset) $allowedArc(reset)
    set ancienAllowedArc(read) $allowedArc(read)
    set ancienAllowedArc(logicInhibitor) $allowedArc(logicInhibitor)

    checkbutton $s.arc.reset -text [mc "Reset arcs"]  -variable allowedArc(reset) \
	-relief flat -anchor w -selectcolor red -command "validArc $w $c"
    pack $s.arc.reset -side top -pady 2 -anchor w
    
    checkbutton $s.arc.read -text [mc "Read arcs"]  -variable allowedArc(read) \
	-relief flat -anchor w -selectcolor red -command "validArc $w $c"
    pack $s.arc.read -side top -pady 2 -anchor w

    checkbutton $s.arc.logicInh -text [mc "Logical inhibitor arcs"]  -variable allowedArc(logicInhibitor)  \
	-relief flat -anchor w -selectcolor red -command "validArc $w $c"
    pack $s.arc.logicInh -side top -pady 2 -anchor w

 


  # Option de fin de calcul
    
    frame $s.stop -relief solid -bd 1
    pack $s.stop -side top -pady 2 -anchor w -fill x
    label $s.stop.label
    pack $s.stop.label -side top -pady 2 -anchor w
    $s.stop.label config -text [mc "Stop conditions (none if -1):"]
#    set ancienAllowedArc(reset) $allowedArc(reset)
    
    frame $s.stop.node
    pack $s.stop.node -side top -pady 2 -anchor w
	entry $s.stop.node.saisie -justify left -textvariable computOption(node) -relief sunken -width 10 -bg white 
	pack $s.stop.node.saisie -side left
    label $s.stop.node.label -text [mc ": nodes (class or symbolic state)"]       	
    pack $s.stop.node.label -side left
    
    
    frame $s.stop.token
    pack $s.stop.token -side top -pady 2 -anchor w
	entry $s.stop.token.saisie -justify left -textvariable computOption(token) -relief sunken -width 10 -bg white
	pack $s.stop.token.saisie -side left
    label $s.stop.token.label -text [mc ": p-bound (max 50 000)"]       	
    pack $s.stop.token.label -side left

 # unfolding stop condition   

    
    frame $s.stop.event
    pack $s.stop.event -side top -pady 2 -anchor w
	entry $s.stop.event.saisie -justify left -textvariable computOption(event) -relief sunken -width 10 -bg white 
	pack $s.stop.event.saisie -side left
    label $s.stop.event.label -text ": maximum events (unfolding)"     	
    pack $s.stop.event.label -side left
    
    frame $s.stop.depth
    pack $s.stop.depth -side top -pady 2 -anchor w
	entry $s.stop.depth.saisie -justify left -textvariable computOption(depth) -relief sunken -width 10 -bg white
	pack $s.stop.depth.saisie -side left
    label $s.stop.depth.label -text ": maximum depth (unfolding)"       	
    pack $s.stop.depth.label -side left
    

    # format des fichiers - espace d'etat et automate
    
#    frame $s.format -relief solid -bd 1
#    pack $s.format -side top -fill x
#    label $s.format.label -text [mc "Output file format:"]
#    pack $s.format.label -side top -pady 2 -anchor w
#    frame $s.format.scg -relief solid -bd 1 
#    pack $s.format.scg -side top -fill x -padx 3 -pady 2
#    label $s.format.scg.label -text [mc "State space:"]
#    pack $s.format.scg.label -side top -pady 2 -anchor w
#    radiobutton $s.format.scg.text -text "Text" -variable outFormat(scg) -value 1 -selectcolor red -command "save_preferences"
#    radiobutton $s.format.scg.mec -text "MEC" -variable outFormat(scg) -value 2  -selectcolor red -command "save_preferences"
#    radiobutton $s.format.scg.aldebaran -text "Aldebaran" -variable outFormat(scg) -value 3  -selectcolor red -command "save_preferences"


#    pack $s.format.scg.text -side top -pady 2 -anchor w
#    pack $s.format.scg.aldebaran -side top -pady 2 -anchor w
#    pack $s.format.scg.mec -side top -pady 2 -anchor w

    # format des fichiers - automate
    
#    frame $s.format.automate -relief solid -bd 1
#    label $s.format.automate.label
#    pack $s.format.automate -side top -fill x -padx 3
#    pack $s.format.automate.label -side top -pady 2 -anchor w
#    $s.format.automate.label config -text [mc "Timed Automata:"]
#    radiobutton $s.format.automate.uppaal -text "UPPAAL" -variable outFormat(ta) -value 1 -selectcolor red -command "save_preferences"
#    radiobutton $s.format.automate.kronos -text "Kronos" -variable outFormat(ta) -value 2  -selectcolor red -command "save_preferences"

#    pack $s.format.automate.uppaal -side top -pady 2 -anchor w
#    pack $s.format.automate.kronos -side top -pady 2 -anchor w
    
    button $s.disable -text [mc "Close"] \
	-command "disableControl $w $c"
    pack $s.disable -side top
}

proc disableControl {w c} {
    global simulatorOn computOption
    global tabPlace tabJeton ok fin tpn

    destroy $w.barreHaut.d.control
    button $w.barreHaut.d.control -text [mc "Control Panel"] -command "controlPanel $w $c" 
    pack $w.barreHaut.d.control -side right -padx 5

   #OPTION MAXTOKEN
    if {[catch {set x [format %d $computOption(token)]} erreur]} { 
	set computOption(token) 50000
    } elseif {($x>50000)||($x<-1)} {
	set computOption(token) 50000 
    } 
    if {[catch {set x [format %d $computOption(node)]} erreur]} { 
	set computOption(node) -1
    } elseif {$x<-1} {
	set computOption(node) -1 
    } 
    if {[catch {set x [format %d $computOption(event)]} erreur]} { 
	set computOption(event) -1
    } elseif {$x<-1} {
	set computOption(event) -1 
    } 
    if {[catch {set x [format %d $computOption(depth)]} erreur]} { 
	set computOption(depth) -1
    } elseif {$x<-1} {
	set computOption(depth) -1 
    } 

    destroy .control
    redessinerRdP $c
}

proc validLimit {} {
global computOption

}
proc validArc {w c} {
    global scheduling parameters allowedArc outFormat typePN
    global simulatorOn computOption
    global ancienAllowedArc
    global modif 
    global tpn


    if {$simulatorOn==0} {
        set modif($tpn) 1
	destroy $w.barreGauche.p
	destroy $w.barreGauche.seph
	creerBarreDessin $w $c
	save_preferences
	redessinerRdP $c 
	set ancienAllowedArc(reset) $allowedArc(reset)
	set ancienAllowedArc(read) $allowedArc(read)
	set ancienAllowedArc(logicInhibitor) $allowedArc(logicInhibitor)
	queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0
    } else {
	set allowedArc(reset) $ancienAllowedArc(reset)
	set allowedArc(read) $ancienAllowedArc(read)
	set allowedArc(logicInhibitor) $ancienAllowedArc(logicInhibitor)
    }
}

proc validParametre {w c} {
    global scheduling allowedArc outFormat parameters typePN computOption
    global simulatorOn
    global ancienMode
    global modif tpn

    if {$simulatorOn==0} {
	# remarque $ancienMode(parameters) + $parameters <3 signfie que l'un des deux modes n'est pas parametrique
	if {($ancienMode(parameters) != $parameters)} {
	    if {($ancienMode(parameters) + $parameters <3)} {
		heriterContrainteTempo $parameters $tpn
		menuHaut $w $c 0
		redessinerRdP $c 
		checkDejaOuvert
	    }
	    queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0
#	    if {$parameters == 2 } {
#		.control.frame.parametre.integer.hull.nofull configure -state active
#		.control.frame.parametre.integer.hull.full configure -state active
#	    } else {
#		.control.frame.parametre.integer.hull.nofull configure -state disabled
#		.control.frame.parametre.integer.hull.full configure -state disabled
#	    }
	    set ancienMode(parameters) $parameters 
#	    set ancienMode(hull) $computOption(hull)
	    save_preferences
        }
    } else {
	set parameters $ancienMode(parameters)
#	set computOption(hull) $ancienMode(hull)
    }
}

proc validControl {w c} {
    global  allowedArc outFormat typePN parameters computOption
    global simulatorOn
    global ancienMode 
    global modif tpn

#    if {$parameters == 2} {
#      set hullOk "active"
#    } else {	
#       set hullOk "disabled"
#    }
    if {$simulatorOn==0} {
	if {$ancienMode(typePN) != $typePN} {
		# -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn
	   if {$typePN==-1} {
		    if {$allowedArc(timedInhibitor) ==0} {
			set allowedArc(timedInhibitor) 1
			destroy $w.barreGauche.p
			destroy $w.barreGauche.seph
			creerBarreDessin $w $c
		    }
		    .control.frame.optionTPN.define configure -state disabled
		    .control.frame.parametre.paramNo configure -state active
		    .control.frame.parametre.paramYes configure -state active
		    .control.frame.parametre.paramInt configure -state active
#		    .control.frame.parametre.integer.hull.nofull configure -state $hullOk
#		    .control.frame.parametre.integer.hull.full configure -state $hullOk

	   } elseif {$typePN==-2} {
		    if {$allowedArc(timedInhibitor) ==1} {
			set allowedArc(timedInhibitor) 0
			destroy $w.barreGauche.p
			destroy $w.barreGauche.seph
			creerBarreDessin $w $c
		    }
		    set parameters 0 
		    .control.frame.optionTPN.define configure -state active
		    .control.frame.parametre.paramNo configure -state disabled
		    .control.frame.parametre.paramYes configure -state disabled
		    .control.frame.parametre.paramInt configure -state disabled
#		    .control.frame.parametre.integer.hull.nofull configure -state disabled
#		    .control.frame.parametre.integer.hull.full configure -state disabled

	   } elseif {$typePN==1} {
		    if {$allowedArc(timedInhibitor) ==1} {
			set allowedArc(timedInhibitor) 0
			destroy $w.barreGauche.p
			destroy $w.barreGauche.seph
			creerBarreDessin $w $c
		    }
		    .control.frame.optionTPN.define configure -state disabled
		    .control.frame.parametre.paramNo configure -state active
		    .control.frame.parametre.paramYes configure -state active
		    .control.frame.parametre.paramInt configure -state active
#		    .control.frame.parametre.integer.hull.nofull configure -state $hullOk
#		    .control.frame.parametre.integer.hull.full configure -state $hullOk
	   } elseif {$typePN==2} {
		    if {$allowedArc(timedInhibitor) ==1} {
			set allowedArc(timedInhibitor) 0
			destroy $w.barreGauche.p
			destroy $w.barreGauche.seph
			creerBarreDessin $w $c
		    }
		    set parameters 0
		    .control.frame.optionTPN.define configure -state disabled
		    .control.frame.parametre.paramNo configure -state disabled
		    .control.frame.parametre.paramYes configure -state disabled
		    .control.frame.parametre.paramInt configure -state disabled
#		    .control.frame.parametre.integer.hull.nofull configure -state disabled
#		    .control.frame.parametre.integer.hull.full configure -state disabled
	   }

	    if {$ancienMode(parameters)!=$parameters} {heriterContrainteTempo $parameters $tpn}

	    save_preferences
	    menuHaut $w $c 0
	    redessinerRdP $c 
  	    queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0
 	    set ancienMode(typePN) $typePN 
	    set ancienMode(parameters) $parameters

            checkDejaOuvert
      }
    } else {
	set typePN $ancienMode(typePN)
    }
}

