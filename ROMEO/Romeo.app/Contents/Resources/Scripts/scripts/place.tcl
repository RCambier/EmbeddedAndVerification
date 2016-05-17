# procedure menuHaut : creation du menu pricipale
# procedure place : creation de la fenetre d'edition du TPN
# procedures associes au menu DELETE : queCreerDetruirePTLPTF 
# procedure associe au menu Scheduler : definirProcesseur
# procedure associe au menu Option : MAP, ecrireMap
# procedure ecrire dans la ligne du bas




#******************************* CREATION DU MENU ******************************

proc menuHaut {w c prems} {
    global cheminFichiers cheminExe
    global modif nomRdP
    global tabPlace tabTransition nbProcesseur tpn
    global tabFlechePT tabFlecheTP newFPT newFTP
    global deltaX deltaY maxX maxY
    global dos editAuto francais parameters synchronized typePN computOption
    global gpnU gpnK mercutioU mercutioK
    global choixOrdo
    global parser
    global versionRomeo
    global zoom plateforme
    global tabConstraint
    global nbConstraints
    
    # choixOrdo ne sert à rien mais peut etre plus tard...
    
    global fin ok destroy
    global detruirePlace detruireTransition detruireFleche
    global creerLien creerPlace creerTransition
    global detruireNoeud creerNoeud
    global infini
    global firstTime
    
    # création des menu
# Avec la version 8.6 de wish il n'y aura pas besoin de détruire les menus mais avec la 8.5 il faut   
#    if { $firstTime(menu) == 1} {
#    	set firstTime(menu) 0
    if { $firstTime(menu) == 1} {
    	set firstTime(menu) 0
    } else {
       destroy .romeo_menu
    }
       menu .romeo_menu
        .romeo_menu add cascade -label [mc "File"] -menu .romeo_menu.file
        menu .romeo_menu.file -tearoff 0
        # création des items du menu File
        .romeo_menu.file add command -label [mc "New"]  -command "nouveauRdP $w $c " -accelerator "Ctrl+N"
        .romeo_menu.file add command -label [mc "Open..."] -command "ouvrirOnglet $w $c" -accelerator "Ctrl+O"
        .romeo_menu.file add command -label [mc "Close"] -command "fermerOngletCourrant $w $c" -accelerator "Ctrl+F"
        .romeo_menu.file add separator
        .romeo_menu.file add command -label [mc "Save"]  -command "aiguillageEnregistrer $w" -accelerator "Ctrl+S"
        .romeo_menu.file add command -label [mc "Save as..."]  -command "enregistrerSousRdP $w" 
        .romeo_menu.file add separator
        .romeo_menu.file add command -label [mc "Export to PostScript..."]  -command "imprimer $w $c"
        .romeo_menu.file add command -label [mc "Export to GasTeX..."]  -command "export2gastex $c"
        .romeo_menu.file add command -label [mc "Export to TINA..."] -command "export2tina $c" 
        #  .romeo_menu.file add command -label [mc "Export to MarkG..."] -command "export2MarkG $c 0"
        #  .romeo_menu.file add command -label [mc "Export to MarkG (untimed)..."] -command "export2MarkG $c 1"
        .romeo_menu.file add command -label [mc "Import from TINA..."]  -command "importFromTina $c" 

# DESACTIVATION de OSATE 2 ROMEO        
#      if {![string compare $plateforme "windows"]} {
#        .romeo_menu.file add command -label "Import from OSATE (.AAXL)..."  -command "importFromOsate $c"
#      }  
        .romeo_menu.file add separator
        .romeo_menu.file add command -label [mc "Exit"]  -command "quitterRdP $w"
        
        # autre proposition d'organisation des menus
        # menu édition
        menu .romeo_menu.edit -tearoff 0
        .romeo_menu add cascade -label [mc "Edit"] -menu .romeo_menu.edit
        
        #edition place
        .romeo_menu.edit add command -label [mc "Place"] -command "queCreerDetruirePTLPTF $w 1 0 0 0 0 0 0 0" -accelerator "Ctrl+P"
        
        #edition transition
        .romeo_menu.edit add command -label [mc "Transition"] -command "queCreerDetruirePTLPTF $w 0 1 0 0 0 0 0 0" -accelerator "Ctrl+T"
        
        #edition arc
        menu .romeo_menu.edit.arc -tearoff 0
        .romeo_menu.edit add cascade -label [mc "Arc..."] -menu .romeo_menu.edit.arc
        .romeo_menu.edit.arc add command -label [mc "Add"] -command "queCreerDetruirePTLPTF $w 0 0 1 0 0 0 0 0" -accelerator "Ctrl+A"
        .romeo_menu.edit.arc add command -label [mc "Delete"] -command "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 1 0"
        .romeo_menu.edit.arc add command -label [mc "Reset arc"] -command "resetArcSelect $w" -accelerator "Ctrl+R"
        .romeo_menu.edit.arc add command -label [mc "Add Nail"] -command "queCreerDetruirePTLPTF $w 0 0 0 1 0 0 0 0"
        .romeo_menu.edit.arc add command -label [mc "Delete Nail"] -command "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 1"
        
        #copier/coller/couper 
        .romeo_menu.edit add separator 
        .romeo_menu.edit add command -label [mc "Select"] -command "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0" -accelerator "Ctrl+N"
        .romeo_menu.edit add command -label [mc "Paste selection"] -command "copierLaSelection $c" -accelerator "Ctrl+V"
        .romeo_menu.edit add command -label [mc "Delete selection"] -command "detruireLaSelection $c" -accelerator "Del"
        .romeo_menu.edit add command -label [mc "Delete"] -command "queCreerDetruirePTLPTF $w 0 0 0 0 1 1 1 1"

        # Séparateur
        .romeo_menu.edit add separator 
        # Préférences
        .romeo_menu.edit add command -label [mc "Preferences"] -command "MAP $w $c"
                
        # menu pn
        menu .romeo_menu.pn -tearoff 0
        .romeo_menu add cascade -label [mc "PN"] -menu .romeo_menu.pn
        .romeo_menu.pn add command -label [mc "Marking Graph"]  -command "calculGDC 0 m"
        
	#typePN : -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn

        #menu p-tpn

         if {($typePN==2)&&($parameters==0)} {
	    menu .romeo_menu.ptpn -tearoff 0 
	    .romeo_menu add cascade -label "P-TPN" -menu .romeo_menu.ptpn
#        .romeo_menu.ptpn add command -label [mc "State-Class Graph"] -command "stateSpacePTPN 2" 
#        .romeo_menu.ptpn add separator
	    .romeo_menu.ptpn add command -label [mc "Zone-Based Graph"] -command "stateSpacePTPN 1"
        }

        #menu t-tpn
        if {($typePN==1)&&($parameters==0)} {
	    menu .romeo_menu.tpn -tearoff 0 
	    .romeo_menu add cascade -label "T-TPN" -menu .romeo_menu.tpn
	    .romeo_menu.tpn add command -label [mc "State-Class Graph"] -command "calculGDC 0 g" 
	    .romeo_menu.tpn add command -label [mc "State-Class Timed Automaton"] -command "calculGDC 0 a" 
	    .romeo_menu.tpn add separator
	    .romeo_menu.tpn add command -label "[mc "Zone-Based Graph"] (Inclusion)" -command "calculZBG 0 0"
	    .romeo_menu.tpn add command -label "[mc "Zone-Based Graph"] (LTL)" -command "calculZBG l 0"
	    .romeo_menu.tpn add command -label [mc "Marking Timed Automaton"] -command "calculZBG 0 a" 
	    .romeo_menu.tpn add separator
	    .romeo_menu.tpn add command -label "Unfold" -command "unfolding 0" 
	    .romeo_menu.tpn add separator
	    .romeo_menu.tpn add command -label [mc "Structural translation to Timed Automaton (UPPAAL format)"] -command "genererAutomateUPPAALSous"
	    .romeo_menu.tpn add command -label [mc "Transitions/Places index"] -command "afficheCorresUPPAAL"
	}

        # menu setpn ou stopwatches
        if {($typePN<0)&&($parameters==0)} {
	    menu .romeo_menu.setpn -tearoff 0
	    .romeo_menu add cascade -label "Stopwatch-PN" -menu .romeo_menu.setpn
	    .romeo_menu.setpn add command -label [mc "Overapproximation of Extended State-Class Graph"] -command "calculGDC d g"
	    .romeo_menu.setpn add command -label [mc "Exact computation (polyhedral) of Extended SCG"] -command "calculGDC p g"
	    .romeo_menu.setpn add command -label [mc "Exact computation (DBM + polyhedra) of  Extended SCG"] -command "calculGDC x g"
	    .romeo_menu.setpn add command -label [mc "State-Class Stopwatch Automaton (-> Hytech format)"] -command "calculGDC d a"
        }
        # menu scheduler
#        menu .romeo_menu.scheduler -tearoff 0
#        .romeo_menu add cascade -label [mc "Scheduler"] -menu .romeo_menu.scheduler
#        .romeo_menu.scheduler add command -label [mc "Define"] -command  "definirProcesseur $c"

	# menu parametric
        if {$parameters>=1} {
	    menu .romeo_menu.paramtpn -tearoff 0
	    .romeo_menu add cascade -label "Parametric-PN" -menu .romeo_menu.paramtpn
	    .romeo_menu.paramtpn add command -label [mc "Parametric State-Class Graph"] -command "calculGDC pp g"
	    .romeo_menu.paramtpn add command -label [mc "Constraints on parameters"] -command "additionalConstraints"
	    .romeo_menu.paramtpn add separator
	    .romeo_menu.paramtpn add command -label "Unfold" -command "unfolding 1" 
	    #        .romeo_menu.ptpn add separator
	}
        
        #menu aide
        menu .romeo_menu.help -tearoff 0
        .romeo_menu add cascade -label [mc "Help"] -menu .romeo_menu.help
        .romeo_menu.help add command -label [mc "About..."] -command "irccyn"
#        .romeo_menu.help add command -label [mc "Licence..."]
#        .romeo_menu.help add command -label [mc "Contact..."] -command "irccyn"
        .romeo_menu.help add command -label [mc "Help"] -command "aide" -accelerator "Ctrl+H" 

# suppession de l'acolade qui correspond au if qui est supprimé	
 #   }

    # mise à jour de l'état des items de menu

# INUTILE DONC EN COMMENTAIRE CAR ON REFAIT LE MENU A CHAQUE FOIS QUE L ON CHANGE DE CLASSE DE MODELES
#   if { $parameters >= 1} {
#    	for {set i 1} { $i<= [.romeo_menu index end] } { incr i } {
#    		if { [.romeo_menu entrycget $i -label ] == "T-TPN" } {
#    			.romeo_menu entryconfigure $i -state disabled 
#    		}
#    		if { [ .romeo_menu entrycget $i -label ] == "P-TPN" } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#    		if { [.romeo_menu entrycget $i -label] == [mc "Stopwatch-PN"] } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#                if {   [.romeo_menu entrycget $i -label] == [mc "Parametric-PN"] } {.romeo_menu entryconfigure $i -state normal}
#    	}
#    } elseif {  $typePN == 1 } {
#	# typePN :  1 : T-TPN ;   2 P-TPN  
#
#    	# les indices changent suivant la plateforme, utilise le label pour
#    	# détecter les bons items à activer
#    	for {set i 1} { $i<= [.romeo_menu index end] } { incr i } {
#    		if { [.romeo_menu entrycget $i -label ] == "T-TPN" } {
#    			.romeo_menu entryconfigure $i -state active 
#    		}
#    		if { [ .romeo_menu entrycget $i -label ] == "P-TPN" } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#    		if { [.romeo_menu entrycget $i -label] == [mc "Stopwatch-PN"] } {
#    			.romeo_menu entryconfigure $i -state disabled 
#    		}
#                if {   [.romeo_menu entrycget $i -label] == [mc "Parametric-PN"] } {.romeo_menu entryconfigure $i -state disabled}
#    	}
#    } elseif {  $typePN == 2 } {
#	# typePN :  1 : T-TPN ;   2 P-TPN  
#    	for {set i 1} { $i<= [.romeo_menu index end] } { incr i } {
#    		if { [.romeo_menu entrycget $i -label ] == "P-TPN" } {
#    			.romeo_menu entryconfigure $i -state active 
#    		}
#    		if { [ .romeo_menu entrycget $i -label ] == "T-TPN" } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#    		if { [.romeo_menu entrycget $i -label] == [mc "Stopwatch-PN"] } {
#    			.romeo_menu entryconfigure $i -state disabled 
#    		}
#                if {   [.romeo_menu entrycget $i -label] == [mc "Parametric-PN"] } {.romeo_menu entryconfigure $i -state disabled}
#    	}
#    } elseif { $typePN <= -1 } {
#	# typePN :  -1 : stopwatch ;   -2 scheduling 
#    	for {set i 1} { $i<= [.romeo_menu index end] } { incr i } {
#    		if { [ .romeo_menu entrycget $i -label ] == [mc "T-TPN"] } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#    		if { [ .romeo_menu entrycget $i -label ] == "P-TPN" } {
#    			.romeo_menu entryconfigure $i -state disabled
#    		}
#    		if { [.romeo_menu entrycget $i -label] == [mc "Stopwatch-PN"] } {
#    			.romeo_menu entryconfigure $i -state normal
#    		}
#                if {   [.romeo_menu entrycget $i -label] == [mc "Parametric-PN"] } {.romeo_menu entryconfigure $i -state disabled}
#    	}
#    }

   if {($typePN <= -1)||($parameters>=1)} {
	for {set i 1} { $i<= [.romeo_menu.file index end] } { incr i } {
	    if {[.romeo_menu.file type $i ] == "command"} {
    		if { [.romeo_menu.file entrycget $i -label ] == [mc "Import from TINA..."] } {
   	          .romeo_menu.file entryconfigure $i -state disabled
		}
   		if { [ .romeo_menu.file entrycget $i -label ] == [mc "Export to TINA..."] } {
   	          .romeo_menu.file entryconfigure $i -state disabled
		}
	    }
	}
   } else {
	for {set i 1} { $i<= [.romeo_menu.file index end] } { incr i } {
	    if {[.romeo_menu.file type $i ] == "command"} {
    		if { [ .romeo_menu.file entrycget $i -label ] == [mc "Import from TINA..."] } {
   	          .romeo_menu.file entryconfigure $i -state normal
		}
    		if { [ .romeo_menu.file entrycget $i -label ] == [mc "Export to TINA..."] } {
   	          .romeo_menu.file entryconfigure $i -state normal
		}
            }
	}
   }

}
# fin de la procedure menuHaut

# ********************** CREATION DE LA FENETRE D'EDITION DU TPN **************************

proc procedurePlace {} {
    
    global cheminExe cheminFichiers modif nomRdP
    global tabPlace tabTransition nbProcesseur tpn
    global tabFlechePT tabFlecheTP newFPT newFTP
    global deltaX deltaY maxX maxY
    global dos editAuto francais synchronized typePN
    global gpnU gpnK mercutioU mercutioK
    global quadrillage
    global zoom plateforme
    
    # Initialisation des variables booleennes globales
    global fin ok destroy
    global detruirePlace detruireTransition detruireFleche
    global creerLien creerPlace creerTransition
    global detruireNoeud creerNoeud
    global versionRomeo
    global maxX maxY
    global boutonDessin
    global firstTime
    global property

    # pour cacher la fenetre principale
    wm withdraw .

    set r .romeo
#    catch {destroy $r}

    #hack pour une vraie barre de menu :p
    toplevel $r -menu .romeo_menu 
    
    #  wm visual $r best
    wm title $r "ROMEO"
    wm iconname $r "Romeo"
    #focus -force.romeo
	wm geometry .romeo +0+25
    wm protocol $r WM_DELETE_WINDOW {quitterRdP .romeo}
    set w $r.global
    #  $w config  

    set c $w.frame.c

    frame $w
    pack $w -side left -expand yes -fill both
    #++++++++++++++ creation de la barre du haut et du menu

    menuHaut $w $c 1


    #++++++++++++++ creation de la deuxieme barre du haut
    frame $w.barreHaut 
    pack $w.barreHaut -side top -expand 0


    button $w.barreHaut.insert -text [mc "Insert"] -command "ouvrirPointXML $w $c 1 0" 
    pack configure $w.barreHaut.insert -side left -padx 5

    if {[catch {package require BWidget}]} {
    } else {
	set boxOpen [ButtonBox $w.barreHaut.boxOpen -spacing 0 -padx 1 -pady 1]
	$boxOpen add -image [Bitmap::get new] \
	    -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
	    -helptext [mc "Create a new net"] -command "nouveauRdP $w $c"
	$boxOpen add -image [Bitmap::get open] \
	    -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
	    -helptext [mc "Open an existing net"] -command "ouvrirOnglet $w $c"
	$boxOpen add -image [Bitmap::get save] \
	    -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
	    -helptext [mc "Save the net"] -command "aiguillageEnregistrer $w"
	pack $boxOpen -side left -anchor w

	set sep [Separator $w.barreHaut.sep -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w
    }

    creerBoutonZoom $w $c
    
    canvas $w.barreHaut.grid -width 27 -height 27 -bg white
    pack $w.barreHaut.grid -side left
    set motifBouton [$w.barreHaut.grid create rect 2 2 30 30 -width 1 -outline white \
			 -fill gray93]
    $w.barreHaut.grid addtag boutonDessin withtag $motifBouton
    $w.barreHaut.grid bind boutonDessin <Button-1> "basculeGrille $c"
    
    for {set i 2} {$i<28} {set i [expr $i+7]} {
	set ligneH($i) [$w.barreHaut.grid create line $i 4 $i 28 -width 1 -fill gray40]     
	set ligneV($i) [$w.barreHaut.grid create line 4 $i 28 $i -width 1 -fill gray40]
	$w.barreHaut.grid addtag lh($i) withtag $ligneH($i)
	$w.barreHaut.grid addtag lv($i) withtag $ligneV($i)
	$w.barreHaut.grid bind lh($i) <Button-1> "basculeGrille $c"
	$w.barreHaut.grid bind lv($i) <Button-1> "basculeGrille $c"
    }
    frame $w.barreHaut.d 
    pack $w.barreHaut.d -side right -padx 5
    button $w.barreHaut.d.control -text [mc "Control Panel"] -command "controlPanel $w $c" 
    pack configure $w.barreHaut.d.control -side right -padx 5

    button $w.barreHaut.check -text [mc "Check"] -command "checkProperty" 
    pack configure $w.barreHaut.check -side right -padx 5


    button $w.barreHaut.simulate -text [mc "Simulate"] -command "simulateTPN $w $c" -state normal
    pack configure $w.barreHaut.simulate -side right -padx 5 

    button $w.barreHaut.edit -text [mc "Edit"] -command "editTPN $w $c" -state disabled
    pack configure $w.barreHaut.edit -side right -padx 5 

   # ++++++++++++++++++++Appel au project manager +++++++++++++++++++++++++++

#    button $w.barreHaut.manage -text [mc "Project Manager"] -command "openProject" 
#    pack configure $w.barreHaut.manage -side right -padx 5


 #++++++++++++++ creation de la  barre d'onglet
    frame $w.onglet 
    pack $w.onglet -side top -expand 0 -fill x 
 $w.onglet configure -relief sunken
    
    # ++++++++++++++++++++ Creation de la Barre de gauche graphique +++++++++++++++++++++++++++

    #[package version BWidget]
    frame $w.barreGauche 
    pack $w.barreGauche -side left -expand 0


    if {[catch {package require BWidget}]} {
	button $w.barreGauche.paste -text [mc "Paste"] -command "copierLaSelection $c" 
	pack  $w.barreGauche.paste -side top -expand 0
	button $w.barreGauche.cut -text [mc "Delete"] -command "detruireLaSelection $c" 
	pack  $w.barreGauche.cut -side top -expand 0
    } else {
	set boxPaste [ButtonBox $w.barreGauche.paste -spacing 0 -padx 1 -pady 1]
	set boxCut [ButtonBox $w.barreGauche.cut -spacing 0 -padx 1 -pady 1]

	$boxCut add -image [Bitmap::get cut] \
	    -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 4 -pady 1 \
	    -helptext [mc "Cut selection"] -command "detruireLaSelection $c"
	$boxPaste add -image [Bitmap::get paste] \
	    -highlightthickness 0 -takefocus 1 -relief link -borderwidth 1 -padx 1 -pady 1 \
	    -helptext [mc "Paste selection"] -command "copierLaSelection $c"

	pack $boxCut -side top
	pack $boxPaste -side top
	#button $w.barreGauche.b1 -bitmap [Bitmap::get paste]
    }


    canvas $w.barreGauche.sep -width 20 -height 5 
    pack $w.barreGauche.sep -side top

    # ****+++++ Creation de la Barre <Place Transition arc noeud Selectionner detruire> ++++++*****

    creerBarreDessin $w $c

    # ++++++++++++++++++++ Creation de la ligne du bas +++++++++++++++++++++++++++

    frame $w.ligneDuBas 
    pack $w.ligneDuBas -side bottom -fill x 
    #-padx 10

    # +++++++++++++++ Creation du bouton ROMEO dans la ligne du bas++++++++++++++++++
 #   image create photo romeo -file [file join "img/romeo.png"]

  #  button $w.ligneDuBas.bouton-romeo -image romeo -command "irccyn" 
  #  pack configure $w.ligneDuBas.bouton-romeo -side left

    # *********
    frame $w.ligneDuBas.indication 
    pack $w.ligneDuBas.indication -side left -fill x 
    #-pady 2m

    label $w.ligneDuBas.indication.nomRdp 
    pack $w.ligneDuBas.indication.nomRdp -side left
 #   $w.ligneDuBas.indication.nomRdp config -text "TPN : $nomRdP($tpn)"

    #  button $w.ligneDuBas.message -text "Selection   Esc" -command "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0" -state disabled 
    #  pack  $w.ligneDuBas.message -side left -expand 1


    # ++++++++++++++++ Creation du menu IRCCyN dans la ligne du bas ++++++++++++++++++

   # image create photo labo -file "img/logolabo.png"
   # button $w.ligneDuBas.bouton-irccyn -image labo -command "irccyn" 
   # pack configure $w.ligneDuBas.bouton-irccyn -side right

    # ++++++++++++++++ Creation de la fenetre d'affichage ++++++++++++++++++
    frame $w.out  
    pack $w.out -side bottom -fill x -padx 1
    #-pady 2m -padx 10

    text $w.out.texte -yscrollcommand "$w.out.vscroll set" -width 100 -height 6 -bg white -wrap word
    scrollbar $w.out.vscroll -command "$w.out.texte yview"  
    pack $w.out.texte -side left -fill both -expand yes
    pack $w.out.vscroll -side right -fill y
    affiche \
"--------------------------------------------------------------------------------------------
 $versionRomeo  Copyright (c) All rights reserved                                            
                                                                                            
 IRCCyN (Institut de Recherche en Communications et Cybernétique de Nantes) - UMR CNRS 6597
--------------------------------------------------------------------------------------------"

# creation du canvas et des ascenceurs ()rappel c = w.frame.c)

  canvasAsc $w $c
#******************Racourci commande + click sur la fenetre : creation
  event add <<Quit>> <Control-Q> <Control-q> <Command-Q> <Command-q> 
  event add <<Paste>> <Control-V> <Control-v> <Command-V> <Command-v>
  event add <<Save>> <Control-S> <Control-s> <Command-S> <Command-s>
  event add <<Open>> <Control-O> <Control-o> <Command-O> <Command-o>
  event add <<New>> <Control-N> <Control-n> <Command-N> <Command-n>
  event add <<AddP>> <Control-P> <Control-p>
  event add <<AddT>> <Control-T> <Control-t>
  event add <<AddA>> <Control-A> <Control-a>
  event add <<AddR>> <Control-R> <Control-r>
  event add <<Suppr>> <BackSpace> <Delete>
  event add <<Echap>> <Escape>

  bind .romeo <<Quit>> "quitterRdP $w"
  bind .romeo <<Paste>> "copierLaSelection $c"
  bind .romeo <<AddP>> "queCreerDetruirePTLPTF $w 1 0 0 0 0 0 0 0"
  bind .romeo <<AddT>> "queCreerDetruirePTLPTF $w 0 1 0 0 0 0 0 0"
  bind .romeo <<AddR>> "queCreerDetruirePTLPTF $w 0 0 2 0 0 0 0 0"
  bind .romeo <<AddA>> "queCreerDetruirePTLPTF $w 0 0 1 0 0 0 0 0"
  bind .romeo <<Save>> "aiguillageEnregistrer $w"
  bind .romeo <<Open>> "ouvrirOnglet $w $c"
  bind .romeo <<New>> "nouveauRdP $w $c"
  bind .romeo <<Suppr>> "detruireLaSelection $c"
  bind .romeo <<Echap>> "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0"

#  bind $w <B3-MouseWheel> "puts "
  bind $w <Up> "$c yview scroll -3 units"
  bind $w <Down> "$c yview scroll +3 units"
  bind $w <Left> "$c xview scroll -3 units"
  bind $w <Right> "$c xview scroll +3 units"
# event add  <<scroll>> <Up>

#  bind $c <MouseWheel> "puts $nomRdP" 
# event add  <<scroll>> <MouseWheel-2>

# peut etre a mettre dans l'initialisation :
  set plot(lastX) 0
  set plot(lastY) 0
  
  load_LastOpenFile $w $c
}

#fin de la procedure place
#******************************************************************
# creation du canvas et des ascenceurs

proc canvasAsc {w c} {
    global maxX maxY zoom
    global synchronized

    destroy $w.frame
    frame $w.frame 
    pack $w.frame -side top -fill both -expand yes

    # rappel c = w.frame.c

    set liste [list 0 0 [expr $maxX*$zoom] [expr $maxY*$zoom]]
    canvas $c -scrollregion $liste -width 550 -height 350 \
	-relief sunken -borderwidth 2 \
	-xscrollcommand "$w.frame.hscroll set" \
	-yscrollcommand "$w.frame.vscroll set" 
    scrollbar $w.frame.vscroll -command "$c yview" 
    scrollbar $w.frame.hscroll -orient horiz -command "$c xview" 

    # dessin des ascenceurs : 

    grid $c -in $w.frame \
	-row 0 -column 0 -rowspan 1 -columnspan 1 -sticky news
    grid $w.frame.vscroll \
	-row 0 -column 1 -rowspan 1 -columnspan 1 -sticky news
    grid $w.frame.hscroll \
	-row 1 -column 0 -rowspan 1 -columnspan 1 -sticky news
    grid rowconfig    $w.frame 0 -weight 1 -minsize 0
    grid columnconfig $w.frame 0 -weight 1 -minsize 0

    # ++++++ le fond blanc

    $c config -bg white

    set font1 {Times 12}
    set font2 {Helvetica 24 bold}

    redessinerRdP $c
    queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0
    #******************Racourci commande + click sur la fenetre : creation

    bind $c <B1-Motion> "moveSurCanvas $c %x %y"
    bind $c <Button-1> "downSurCanvas $c %x %y"
    bind $c <ButtonRelease-1> "releaseSurCanvas $c %x %y"
    bind $c <Button-3> "clickDroitSurCanvas $c %x %y"
    bind $c <Button-2> "clickDroitSurCanvas $c %x %y"
    
}


#******************************************************************
# ++++++ le fond quadrill

proc grille c {
    global maxX maxY zoom quadrillage

    if $quadrillage {
	for {set i 1} {$i<$maxX} {set i [expr $i+30]} {
	    $c create line $i 00 $i $maxY -width 1 -fill gray
	}
	for {set i 1} {$i<$maxY} {set i [expr $i+30]} {
	    $c create line 00 $i $maxX $i -width 1 -fill gray
	}
	$c create line 0 $maxY $maxX $maxY -width 2 -fill blue
	$c create line $maxX 0 $maxX $maxY -width 2 -fill blue
    } 
}


proc basculeGrille c {
    global quadrillage

    if $quadrillage { 
	set quadrillage 0
    } else {
	set quadrillage 1
    }
    redessinerRdP $c 
} 
#******************************************************************

proc resetArcSelect {w} {
global allowedArc
 if {$allowedArc(reset)} {  
   queCreerDetruirePTLPTF $w 0 0 2 0 0 0 0 0 
 } elseif {$allowedArc(read)} {  
   queCreerDetruirePTLPTF $w 0 0 3 0 0 0 0 0 
 } elseif {$allowedArc(logicInhibitor)} {  
   queCreerDetruirePTLPTF $w 0 0 4 0 0 0 0 0 
 } elseif {$allowedArc(timedInhibitor)} {  
   queCreerDetruirePTLPTF $w 0 0 5 0 0 0 0 0 
 } else {
   queCreerDetruirePTLPTF $w 0 0 1 0 0 0 0 0 
 }
} 

#******** MISE a JOUR du nombre de processeur ***************

proc definirProcesseur {r} {
    global nb
    global nbProcesseur tpn typePN
    global francais
    global choixOrdo
    global modif
    
    set f .fenetreProcesseur
    catch {destroy $f}
    toplevel $f
    wm title $f [mc "Scheduling extension"]
    
    set choixOrdo 0
    
    frame $f.scheduler -relief ridge -bd 2 -height 2
    label $f.scheduler.commentaire
    radiobutton $f.scheduler.priority -text [mc "Preemptive Scheduling \n based on static priority"]  -variable choixOrdo  -relief flat  -value 0  -width 20 -anchor w
    
    pack $f.scheduler.priority -side top -pady 2 -anchor w -fill x
    pack $f.scheduler -side top -fill x

    set nb $nbProcesseur($tpn)
    frame $f.nbProc -relief ridge -bd 2 -height 2
    entry $f.nbProc.saisienbProc -justify left -textvariable nb -relief sunken -width 5 -bg white
    label $f.nbProc.label
    label $f.nbProc.titre
    pack $f.nbProc.titre -side top
    pack $f.nbProc.label -side left
    pack $f.nbProc.saisienbProc -side left
    $f.nbProc.label config -text [mc "Number of CPU: "]
    $f.nbProc.titre config -text [mc "Hardware Architecture"]

    pack $f.nbProc -side top -fill x
    bind $f <Return> "validerProc $r $f"
    frame $f.buttons
    pack $f.buttons -side bottom -fill x -pady 2m
    button $f.buttons.annuler -text [mc "Cancel"] -command  "destroy $f"
    button $f.buttons.accepter -default active -text [mc "Ok"]  -command "validerProc $r $f"
    pack $f.buttons.annuler $f.buttons.accepter  -side left -expand 1

    # ++++++ procedure interne à la procedure definriProcesseur

    proc validerProc {c fl} {
	global nb
	global nbProcesseur
	global modif tpn

	set modif($tpn) 1
	set x [format %d $nb]

	if {$nb >= 0} {
	    if {$nb>10} {set nb 10}
	    set pourTest $nbProcesseur($tpn)
	    set nbProcesseur($tpn) $nb
	    destroy $fl
	    if {$nb < $pourTest}  {  redessinerRdP $c }
	} else {
	    set button [tk_messageBox -message [mc "Error: number of CPU < 0"]]
	}
    }
    # fin de la procedure definirProcesseur
}

#******** MISE a JOUR du chemin OPTION MAP ***************

proc MAP {w c} {
    global cheminExe cheminPref
    global cheminFichiers
    global cheminEditeur
    global dos
    global editAuto
    global francais
    global cheminExe
    global typePN allowedArc outFormat 
    global maxX maxY
    global gpnU gpnK mercutioU mercutioK
    global couleurCourante tabColor resultatCouleur tabColorLocal defaultTabColor

    set ancienneLangue $francais
#    set ancienSchedule $scheduling
 

    set top .fenetreHome
    catch {destroy $top}
    toplevel $top
    wm title $top "options"

    $top config 

    frame $top.fcheminFichiers -bd 2 
    entry $top.fcheminFichiers.saisieCheminFichiers -justify left -textvariable cheminFichiers -relief sunken -width 70 -bg white
    label $top.fcheminFichiers.labelCheminFichiers 
    pack $top.fcheminFichiers.labelCheminFichiers -side left
    pack $top.fcheminFichiers.saisieCheminFichiers -side left
    $top.fcheminFichiers.labelCheminFichiers config -text [mc "Work Directory: "]

    button $top.fcheminFichiers.browse -text [mc "Browse"] -command  "browseChemin $top" 
    pack $top.fcheminFichiers.browse  -side right -expand 1
    pack $top.fcheminFichiers -side top -fill x

#    frame $top.fcheminExe -bd 2 
#    entry $top.fcheminExe.saisieCheminExe -justify left -textvariable cheminExe -relief sunken -width 50 -bg white
#    label $top.fcheminExe.labelCheminExe 
#    pack $top.fcheminExe.labelCheminExe -side left
#    pack $top.fcheminExe.saisieCheminExe -side right
#    $top.fcheminExe.labelCheminExe config -text [mc "Bin Directory: "]
#    pack $top.fcheminExe -side top -fill x

    # taille de la fenetre

    frame $top.dimension -bd 2 
    entry $top.dimension.saisieX -justify left -textvariable maxX -relief sunken -width 7 -bg white
    entry $top.dimension.saisieY -justify left -textvariable maxY -relief sunken -width 7 -bg white
    label $top.dimension.label 
    pack $top.dimension.label -side left
    pack $top.dimension.saisieX -side left
    pack $top.dimension.saisieY -side left
    $top.dimension.label config -text [mc "Window size (x,y): "]
    pack $top.dimension -side top -fill x


    frame $top.coche -relief ridge -bd 1 
    pack $top.coche -side top -fill x


    frame $top.coche.choix -relief ridge -bd 1 
    pack $top.coche.choix -side left 
    frame $top.coche.langue -relief ridge -bd 1 
    pack $top.coche.langue -side left

    label $top.coche.choix.titre -text [mc "Systems: "]
    label $top.coche.langue.titre -text [mc "Language: "]

    pack $top.coche.choix.titre -side top -anchor w
    pack $top.coche.langue.titre -side top -anchor w

    set dos 1
    checkbutton $top.coche.choix.dos -text "dos" -variable dos -width 16  -selectcolor red -state disabled
    pack $top.coche.choix.dos  -side top

    checkbutton $top.coche.choix.unix -text "unix" -variable dos -width 16  -selectcolor red -state disabled
    pack $top.coche.choix.unix -side top


    radiobutton $top.coche.langue.francais -text "Français"  -variable francais -value 1 -width 16 -selectcolor red
    pack $top.coche.langue.francais -side top

    radiobutton $top.coche.langue.anglais -text "English"  -variable francais -value 0 -width 16  -selectcolor red
    pack $top.coche.langue.anglais -side top

    # option de COULEUR ++++++++++++++++++++++++
    #les fichiers des procedures sont dans maniTPN ++++++++++++++++++++++++
    for {set i 0} {$i <= 5}   {incr i} {
      set tabColorLocal(Place,$i) $tabColor(Place,$i) 
      set tabColorLocal(Transition,$i) $tabColor(Transition,$i) 
      set tabColorLocal(Arc,$i) $tabColor(Arc,$i) 
    }
    frame $top.palette -bd 2 -relief sunken
    pack $top.palette -side top
	label $top.palette.label -text [mc "Color setup: "]
	pack $top.palette.label -side top
    frame $top.palette.pta -bd 2
    pack $top.palette.pta -side top
    
    frame $top.palette.pta.colorPlace -bd 2
    pack $top.palette.pta.colorPlace -side left
    paletteCouleur $top.palette.pta.colorPlace Place

    frame $top.palette.pta.colorTransition -bd 2
    pack $top.palette.pta.colorTransition -side left
    paletteCouleur $top.palette.pta.colorTransition Transition
    
    frame $top.palette.pta.colorArc -bd 2
    pack $top.palette.pta.colorArc -side left
    paletteCouleur $top.palette.pta.colorArc Arc
 
    frame $top.palette.buttons 
    pack $top.palette.buttons -side bottom -fill x -pady 2m
    button $top.palette.buttons.default -text [mc "Load default palette"] -command  "defaultPalette $top.palette.pta" 
    pack $top.palette.buttons.default -side left
    button $top.palette.buttons.savedefault -text [mc "Save as default palette"] -command  "saveAsDefaultPalette" 
    pack $top.palette.buttons.savedefault -side left

 
    
    # provisoirement
    set mercutioK 0


    bind $top <Return> "validerChemin $w $c $top $ancienneLangue $maxX $maxY"
    frame $top.buttons 
    pack $top.buttons -side bottom -fill x -pady 2m
    button $top.buttons.annuler -text [mc "Cancel"] -command  "annulerChemin $top" 
    button $top.buttons.accepter -default active  -text [mc "Apply"]  \
	-command "validerChemin $w $c $top $ancienneLangue $maxX $maxY"
    pack $top.buttons.accepter $top.buttons.annuler  -side left -expand 1

    # +++ procedures interne à la procedure map

    proc validerChemin {w c fl ancienneLangue ancienX ancienY} {
        global cheminFichiers
        global cheminEditeur
        global cheminExe
        global editAuto
        global dos
        global francais
        global typePN allowedArc outFormat
	global maxX maxY zoom
        global gpnU gpnK mercutioU mercutioK
        global tabColor tabColorLocal
        
    for {set i 0} {$i <= 5}   {incr i} {
      set tabColor(Place,$i) $tabColorLocal(Place,$i) 
      set tabColor(Transition,$i) $tabColorLocal(Transition,$i) 
      set tabColor(Arc,$i) $tabColorLocal(Arc,$i) 
    }
	set echap [format %f $maxX]
	set echap [format %f $maxY]
	ajusteTaille
	destroy $fl
	set dos 0
	save_preferences
	if {($maxX != $ancienX)||($maxY!=$ancienY)} {
	    #	     destroy $w
	    #	     procedurePlace
	    destroy $w.frame
	    canvasAsc $w $c
	} elseif {($ancienneLangue!=$francais)} {
	    menuHaut $w $c 0
	}
	 redessinerRdP $c

    }

    proc annulerChemin {fl} {
        global cheminFichiers
        global cheminEditeur
 	global dos
        global editAuto
	global francais
        global cheminExe
        global typePN allowedArc outFormat
	global maxX maxY

	destroy $fl
	load_preferences
#	source scripts/map.tcl
#	chemin
    }

    proc browseChemin {top} {
        global cheminFichiers

         if {[file exists $cheminFichiers]} {
            set cheminFichiersReq [tk_chooseDirectory -initialdir $cheminFichiers]
         } else {
                  set cheminFichiersReq [tk_chooseDirectory]
         }
	    if {[string compare $cheminFichiersReq ""]} {
	      set cheminFichiers $cheminFichiersReq
	    }
   update
    }

    # update selected locale
    update_locale

    # fin de la procedure MAP
}

proc ecrireMap {} {
    global cheminFichiers
    global cheminEditeur
    global cheminExe
    global editAuto
    global dos
    global francais
    global typePN allowedArc outFormat
    global maxX maxY
    global gpnU gpnK mercutioU mercutioK
    global tabColor defaultTabColor

    set fichier "map.tcl"
    set File [open $fichier w]
    puts $File "proc chemin {} {
     global cheminFichiers
     global cheminEditeur 
     global cheminExe
     global dos 
     global editAuto 
     global francais 
     global allowedArc outFormat typePN
     global maxX maxY 
     global gpnU gpnK mercutioU mercutioK \n 
     set outFormat(scg) $outFormat(scg) 
     set outFormat(ta) $outFormat(ta) 
     set typePN $typePN
     set allowedArc(reset) $allowedArc(reset) 
     set allowedArc(read) $allowedArc(read) 
     set allowedArc(logicInhibitor) $allowedArc(logicInhibitor) 
     set allowedArc(timedInhibitor) $allowedArc(timedInhibitor) 
     set dos $dos
     set editAuto $editAuto
     set francais $francais
     set cheminExe \"$cheminExe\" 
     set cheminFichiers \"$cheminFichiers\" 
     set cheminEditeur \"$cheminEditeur\" 
     set maxX $maxX
     set maxY $maxY
     set gpnU $gpnU
     set gpnK $gpnK
     set mercutioU $mercutioU
     set mercutioK $mercutioK
    } "
     for {set i 0} {$i <= 5}   {incr i} {
      puts $File "set tabColor(Arc,$i) $tabColor(Arc,$i)" 
     }

    close $File
}

#******** MISE a JOUR DES BOOLEENS DE DESTRUCTION ***************


proc queCreerDetruirePTLPTF {r cP cT cL cN dP dT dF dN} {

    global detruirePlace
    global detruireTransition
    global detruireFleche
    global creerLien
    global creerPlace
    global creerTransition
    global detruireNoeud
    global creerNoeud
    global select
    global boutonDessin
    global allowedArc typePN


    if {$cP + $cT + $cL + $cN} {
	set select(vide) 1
	set select(listePlace) [list]
	set select(listeLabelPlace) [list]
	set select(listeTransition) [list]
	set select(listeLabelTransition) [list]
	set select(listeNoeud) [list]

	if {$cP==1} {afficheBarreDessin $r 2}
	if {$cP==2} {afficheBarreDessin $r 3}
	if {$cT} {afficheBarreDessin $r 4}
	if {$cL==1} {afficheBarreDessin $r 5}
	if {$cN} {afficheBarreDessin $r 6}
	if {$cL==2} {afficheBarreDessin $r 7}
	if {$cL==3} {afficheBarreDessin $r [expr 7 + $allowedArc(reset)]}
	if {$cL==4} {afficheBarreDessin $r [expr 7 + $allowedArc(reset)+ $allowedArc(read)]}
        if {$cL==5} {afficheBarreDessin $r [expr 7 + $allowedArc(reset)+ $allowedArc(read)+$allowedArc(logicInhibitor)]}
#	Preparation pour le prochain arc : if {$cL==6} {afficheBarreDessin $r [expr 7 + $allowedArc(reset)+ $allowedArc(read)+$allowedArc(logicInhibitor)+$allowedArc(timedInhibitor)]}

    } elseif {$dP + $dT + $dF + $dN ==0} {
	afficheBarreDessin $r 0
    } else {afficheBarreDessin $r 1}

    set creerPlace $cP
    set creerTransition $cT
    set creerLien $cL
    set creerNoeud $cN

    set detruirePlace $dP
    set detruireTransition $dT
    set detruireFleche $dF
    set detruireNoeud $dN

    redessinerRdP $r.frame.c
}


# ***********procedure ecrire dans la ligne du bas

proc ecrire {w unTruc} {
    label $w.ligneDuBas.indication.delta
    pack $w.ligneDuBas.indication.delta -side right
    $w.ligneDuBas.indication.delta config -text "$unTruc"
}


proc afficheBarreDessin {w nBouton} {
    global boutonDessin
    for {set i 0} {$i<11}  {incr i} {
	if {$i==$nBouton} {
	    $w.barreGauche.p itemconfig boutonDessin($i) -outline black -fill gray
	} else {
	    $w.barreGauche.p itemconfig boutonDessin($i) -outline gray -fill gray95
	}
    }
}



proc creerBoutonZoom {w c} {
    global zoom

    variable icon
    set icon(zoomIn) R0lGODlhFAATAMIAAMzMzF9fXwAAAP///wAA/8zM/wAAAAAAACH5BAEAAAAALAAAAAAUABMAAANBCLrc/jBKGYQVYao6es2U0FlDJUjimFbocF1u+5JnhKldHAUB7mKom+oTupiImo2AUAAmAQECE/SMWp6LK3arSQAAOw==
    set icon(zoomOut) R0lGODlhFAATAMIAAMzMzF9fXwAAAP///wAA/8zM/wAAAAAAACH5BAEAAAAALAAAAAAUABMAAANCCLrc/jBKGYQVYao6es2U0I2VIIkjaUbidQ0r1LrtGaRj/AQ3boEyTA6DCV1KH82iQigUlYAAoQlUSi3QBTbL1SQAADs=

    image create photo ZoomIn -data $icon(zoomIn)
    image create photo ZoomOut -data $icon(zoomOut)
    pack [button $w.barreHaut.zplus -image ZoomIn -command "zoomPlus $w $c" ] -side left
    pack [button $w.barreHaut.zmoins -image ZoomOut -command "zoomMoins $w $c" ] -side left

}

proc zoomPlus {w c} {
    global zoom

    # pour zoomer vers le milieu :
    # coef de grossissement k =1.5. Glissement =(k-1)/2k

    set deltaX [expr (5*[lindex [$c xview] 0]+[lindex [$c xview] 1])/6]
    set deltaY [expr (5*[lindex [$c yview] 0]+[lindex [$c yview] 1])/6]

    if {$zoom<5} {
	set zoom [expr $zoom*1.5]
	canvasAsc $w $c
	$c xview moveto $deltaX
	$c yview moveto $deltaY 
    }
}

proc zoomMoins {w c} {
    global zoom

    # pour dezoomer à partir du milieu :
    # Glissement du point en haut à gauche : (k-1)/4

    set deltaX [max 0 [expr (5*[lindex [$c xview] 0]-[lindex [$c xview] 1])/4]]
    set deltaY [max 0 [expr (5*[lindex [$c yview] 0]-[lindex [$c yview] 1])/4]]

    if {$zoom>0.2} {
	set zoom [expr $zoom/1.5]
	canvasAsc $w $c
	$c xview moveto $deltaX
	$c yview moveto $deltaY
    }
}

proc creerBarreDessin {w c} {
    global allowedArc typePN
    global dejaHelp
    
       set dejaHelp -1      
     
    set haut [expr 178 + $allowedArc(reset)*23 + $allowedArc(read)*23 + $allowedArc(logicInhibitor)*23+$allowedArc(timedInhibitor)*23]
    canvas $w.barreGauche.p -width 20 -height $haut -relief sunken -borderwidth 2 -bg white
    pack $w.barreGauche.p -side top


# associate all entries of menu .m.file to variable varinfo
# then declare entries of .m.file
    for {set i 0} {$i<7}  {incr i} {
	  set motifBouton [$w.barreGauche.p create rect 1 [expr 25*$i+2] 25 [expr 25*($i+1)] -outline gray \
			     -fill gray95]
	  $w.barreGauche.p addtag boutonDessin($i) withtag $motifBouton
    }

# select et del sont plus loin


    set motifPlace [$w.barreGauche.p create oval 6 [expr 25*2+6] 20 [expr 25*2+20] -width 1 -outline black -state normal \
			-fill SkyBlue2]
 
   set motifToken [$w.barreGauche.p create oval 12 [expr 25*3+12] 16 [expr 25*3+16] -width 1 -outline black -state normal \
			-fill black]

    set motifTransition [$w.barreGauche.p create rect 7 [expr 25*4+10] 19 [expr 25*4+16] -width 1 -outline black \
			     -fill yellow]

    set motifArc [$w.barreGauche.p create line 5 [expr 25*5+4] 18 [expr 25*5+21]  -arrow last -fill black]

    set motifArcNoeud [$w.barreGauche.p create line 5 [expr 25*6+9] 12 [expr 25*6+15] 20 [expr 25*6+19] -fill black]
    set motifNoeud [$w.barreGauche.p create rect 10 [expr 25*6+13] 14 [expr 25*6+17] -width 1 -outline black -fill green]

    $w.barreGauche.p addtag motif(Place) withtag $motifPlace
    $w.barreGauche.p addtag motif(Token) withtag $motifToken
    $w.barreGauche.p addtag motif(Transition) withtag $motifTransition
    $w.barreGauche.p addtag motif(Arc) withtag $motifArc
    $w.barreGauche.p addtag motif(ArcNoeud) withtag $motifArcNoeud
    $w.barreGauche.p addtag motif(Noeud) withtag $motifNoeud
    
    
    if {$allowedArc(reset)==1} {
  	   set motifBouton [$w.barreGauche.p create rect 1 [expr 25*$i+2] 25 [expr 25*($i+1)] -outline gray \
			     -fill gray95]
	    $w.barreGauche.p addtag boutonDessin($i) withtag $motifBouton

	    set xb 16
	    set yb [expr 25*$i+14]
	    set xa 6
	    set ya [expr 25*$i+4]
	    set motifFlush [$w.barreGauche.p create polygon [expr $xb + 3] $yb \
			[expr $xb ] [expr $yb + 3] [expr $xb + 3] [expr $yb + 6] \
			[expr $xb + 6] [expr $yb + 3] -width 1 -outline black -fill black]  
	    set motifArcFlush [$w.barreGauche.p create line $xa $ya [expr $xb + 3] [expr $yb + 3] -tags item -fill black]
	    $w.barreGauche.p addtag motif(flush) withtag $motifFlush   
	    $w.barreGauche.p addtag motif(arcFlush) withtag $motifArcFlush   
            $w.barreGauche.p bind boutonDessin($i) <Button-1> "queCreerDetruirePTLPTF $w 0 0 2 0 0 0 0 0"
            $w.barreGauche.p bind motif(flush) <Button-1> "queCreerDetruirePTLPTF $w 0 0 2 0 0 0 0 0"
            $w.barreGauche.p bind motif(arcFlush) <Button-1> "queCreerDetruirePTLPTF $w 0 0 2 0 0 0 0 0"
 	    $w.barreGauche.p bind boutonDessin($i) <Any-Enter> "afficheHelp %x %y $w $i [mc flush-arc]"

	    incr i
    }
    
    if {$allowedArc(read)==1} {
  	   set motifBouton [$w.barreGauche.p create rect 1 [expr 25*$i+2] 25 [expr 25*($i+1)] -outline gray \
			     -fill gray95]
	    $w.barreGauche.p addtag boutonDessin($i) withtag $motifBouton

	    set xb 16
	    set yb [expr 25*$i+14]
	    set xa 6
	    set ya [expr 25*$i+4]
	    set motifArcRead [$w.barreGauche.p create line $xa $ya [expr $xb + 3] [expr $yb+3] -tags item -fill black]
#	    set motifRead [$w.barreGauche.p create polygon [expr $xb + 3] $yb \
#			$xb [expr $yb + 3] [expr $xb + 3] [expr $yb + 6] \
#			[expr $xb + 6] [expr $yb + 3] -width 1 -outline black -fill lightgray]  
	    set motifRead [$w.barreGauche.p create polygon [expr $xb] $yb \
			[expr $xb+6] [expr $yb] [expr $xb +6] [expr $yb + 6] \
			[expr $xb] [expr $yb + 6] -width 1 -outline black -fill lightgray]  
	    $w.barreGauche.p addtag motif(read) withtag $motifRead   
	    $w.barreGauche.p addtag motif(arcRead) withtag $motifArcRead   
        $w.barreGauche.p bind boutonDessin($i) <Button-1> "queCreerDetruirePTLPTF $w 0 0 3 0 0 0 0 0"
        $w.barreGauche.p bind motif(arcRead) <Button-1> "queCreerDetruirePTLPTF $w 0 0 3 0 0 0 0 0"
        $w.barreGauche.p bind motif(read) <Button-1> "queCreerDetruirePTLPTF $w 0 0 3 0 0 0 0 0"
 	    $w.barreGauche.p bind boutonDessin($i) <Any-Enter> "afficheHelp %x %y $w $i [mc read-arc]"
	    incr i
    }

    if {$allowedArc(logicInhibitor)==1} {
  	   set motifBouton [$w.barreGauche.p create rect 1 [expr 25*$i+2] 25 [expr 25*($i+1)] -outline gray \
			     -fill gray95]
	    $w.barreGauche.p addtag boutonDessin($i) withtag $motifBouton

	    set xb 16
	    set yb [expr 25*$i+14]
	    set xa 6
	    set ya [expr 25*$i+4]  
	    set motifLogicInh [$w.barreGauche.p create oval [expr $xb] [expr $yb] \
			[expr $xb + 6] [expr $yb + 6] -width .5 -outline black -fill orange]  
	    set motifArcLogicInh [$w.barreGauche.p create line $xa $ya [expr $xb] [expr $yb] -tags item -fill black]
	    $w.barreGauche.p addtag motif(logicInh) withtag $motifLogicInh   
	    $w.barreGauche.p addtag motif(arcLogicInh) withtag $motifArcLogicInh   

 	    $w.barreGauche.p bind boutonDessin($i) <Any-Enter> "afficheHelp %x %y $w $i [mc logical-inhibitor-arc]"

        $w.barreGauche.p bind boutonDessin($i) <Button-1> "queCreerDetruirePTLPTF $w 0 0 4 0 0 0 0 0"
        $w.barreGauche.p bind motif(logicInh) <Button-1> "queCreerDetruirePTLPTF $w 0 0 4 0 0 0 0 0"
        $w.barreGauche.p bind motif(arcLogicInh) <Button-1> "queCreerDetruirePTLPTF $w 0 0 4 0 0 0 0 0"
	    incr i
    }
    
    if {$allowedArc(timedInhibitor)==1} {
  	   set motifBouton [$w.barreGauche.p create rect 1 [expr 25*$i+2] 25 [expr 25*($i+1)] -outline gray \
			     -fill gray95]
	    $w.barreGauche.p addtag boutonDessin($i) withtag $motifBouton

	    set xb 16
	    set yb [expr 25*$i+14]
	    set xa 6
	    set ya [expr 25*$i+4]  
	    set motifTimedInh [$w.barreGauche.p create oval [expr $xb] [expr $yb] \
			[expr $xb + 6] [expr $yb + 6] -width 2 -outline black -fill white]  
	    set motifArcTimedInh [$w.barreGauche.p create line $xa $ya [expr $xb] [expr $yb] -tags item -fill black]
	    $w.barreGauche.p addtag motif(timedInh) withtag $motifTimedInh   
	    $w.barreGauche.p addtag motif(arcTimedInh) withtag $motifArcTimedInh   

 	    $w.barreGauche.p bind boutonDessin($i) <Any-Enter> "afficheHelp %x %y $w $i [mc timed-inhibitor-arc]"

        $w.barreGauche.p bind boutonDessin($i) <Button-1> "queCreerDetruirePTLPTF $w 0 0 5 0 0 0 0 0"
        $w.barreGauche.p bind motif(timedInh) <Button-1> "queCreerDetruirePTLPTF $w 0 0 5 0 0 0 0 0"
        $w.barreGauche.p bind motif(arcTimedInh) <Button-1> "queCreerDetruirePTLPTF $w 0 0 5 0 0 0 0 0"
	    incr i
    }

    # et selectionner detruire :

    set motifSelect [$w.barreGauche.p create rect 7 7 22 22  -dash 3 -width 1 -outline black ]
    set motifDel1 [$w.barreGauche.p create line 5 30 20 45 -width 5 -fill red ]
    set motifDel2 [$w.barreGauche.p create line 5 45 20 30  -width 5 -fill red ]

    $w.barreGauche.p addtag motif(Select) withtag $motifSelect
    $w.barreGauche.p addtag motif(Del1) withtag $motifDel1
    $w.barreGauche.p addtag motif(Del2) withtag $motifDel2

    $w.barreGauche.p bind boutonDessin(0) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0"
    $w.barreGauche.p bind boutonDessin(1) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 0 1 1 1 1"

    $w.barreGauche.p bind motif(Select) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0"
    $w.barreGauche.p bind motif(Del1) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 0 1 1 1 1"
    $w.barreGauche.p bind motif(Del2) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 0 1 1 1 1"
    $w.barreGauche.p bind motif(Del1) <Any-Enter> "afficheHelp %x %y $w 1 [mc Delete]" 
    $w.barreGauche.p bind motif(Del2) <Any-Enter> "afficheHelp %x %y $w 1 [mc Delete]" 

    $w.barreGauche.p bind motif(Select) <Any-Enter> "afficheHelp %x %y $w 0 [mc Select]"    
    $w.barreGauche.p bind boutonDessin(0) <Any-Enter> "afficheHelp %x %y $w 0 [mc Select]"    
    $w.barreGauche.p bind boutonDessin(1) <Any-Enter> "afficheHelp %x %y $w 1 [mc Delete]"    
    $w.barreGauche.p bind boutonDessin(2) <Any-Enter> "afficheHelp %x %y $w 2 [mc Place]"
    $w.barreGauche.p bind boutonDessin(3) <Any-Enter> "afficheHelp %x %y $w 3 [mc Token]"
    $w.barreGauche.p bind boutonDessin(4) <Any-Enter> "afficheHelp %x %y $w 4 [mc Transition]"
    $w.barreGauche.p bind boutonDessin(5) <Any-Enter> "afficheHelp %x %y $w 5 [mc Arc]"
    $w.barreGauche.p bind boutonDessin(6) <Any-Enter> "afficheHelp %x %y $w 6 [mc Nail]"
    $w.barreGauche.p bind boutonDessin(2) <Button-1> "queCreerDetruirePTLPTF $w 1 0 0 0 0 0 0 0"
    $w.barreGauche.p bind boutonDessin(3) <Button-1> "queCreerDetruirePTLPTF $w 2 0 0 0 0 0 0 0"
    $w.barreGauche.p bind boutonDessin(4) <Button-1> "queCreerDetruirePTLPTF $w 0 1 0 0 0 0 0 0"
    $w.barreGauche.p bind boutonDessin(5) <Button-1> "queCreerDetruirePTLPTF $w 0 0 1 0 0 0 0 0"
    $w.barreGauche.p bind boutonDessin(6) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 1 0 0 0 0"
    $w.barreGauche.p bind motif(Place) <Button-1> "queCreerDetruirePTLPTF $w 1 0 0 0 0 0 0 0"
    $w.barreGauche.p bind motif(Place) <Any-Enter> "afficheHelp %x %y $w 2 [mc Place]"
    $w.barreGauche.p bind motif(Token) <Button-1> "queCreerDetruirePTLPTF $w 2 0 0 0 0 0 0 0"
    $w.barreGauche.p bind motif(Token) <Any-Enter> "afficheHelp %x %y $w 2 [mc Token]"
    $w.barreGauche.p bind motif(Transition) <Button-1> "queCreerDetruirePTLPTF $w 0 1 0 0 0 0 0 0"
    $w.barreGauche.p bind motif(Transition) <Any-Enter> "afficheHelp %x %y $w 4 [mc Transition]"
    $w.barreGauche.p bind motif(Arc) <Button-1> "queCreerDetruirePTLPTF $w 0 0 1 0 0 0 0 0"
    $w.barreGauche.p bind motif(ArcNoeud) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 1 0 0 0 0"
    $w.barreGauche.p bind motif(Noeud) <Button-1> "queCreerDetruirePTLPTF $w 0 0 0 1 0 0 0 0"
    $w.barreGauche.p bind motif(Arc) <Any-Enter> "afficheHelp %x %y $w 5 [mc Arc]"
    $w.barreGauche.p bind motif(ArcNoeud) <Any-Enter> "afficheHelp %x %y $w 6 [mc Nail]"
    
    canvas $w.barreGauche.seph -width 20 -height 160 
    pack $w.barreGauche.seph -side top


}


 proc afficheHelp {px py w val msg} {

global dejaHelp

  if {$dejaHelp!=$val} {
   set dejaHelp $val
	set x [expr [winfo x .romeo]+[winfo x $w.barreGauche]]
	set y [expr [winfo y $w.barreGauche]+[winfo y $w.barreGauche.p]+$val*25-30]
    set c $w.frame.c

    $c delete helpText
    $c delete help

    set x [posX $c 1] 
    set y [posY $c $y] 

    set motifHelp [$c create rect [expr $x] [expr $y] \
				     [expr $x+15+[string length $msg]*5] [expr $y+20]  -outline black\
		     -fill white]
    set textHelp [$c create text [expr $x+6+[string length $msg]*2.5] [expr $y+10] \
				     -text $msg -justify left]
     $c addtag help withtag $motifHelp
     $c addtag helpText withtag $textHelp
    update
    after 800 { 
      .romeo.global.frame.c delete helpText
      .romeo.global.frame.c delete help
            update
            set dejaHelp -1
    }
 }
#     if {[winfo exists .help]} {destroy .help} 
 #      set dejaHelp(etat) -1   
 #      set dejaHelp(bouton) -1      

    
}

