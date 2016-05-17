# Verification de propriétés du TPN
# Verification syntaxique des propriété
#verification syntaxique des contraintes
#*********
#*
#procedure checkProperty
#*
#*********
proc afficheDialogue {fp texte} {

    $fp.dialogue.retour.syntax insert end  "$texte"
    $fp.dialogue.retour.syntax yview moveto 1
}


proc emptyFile {file} {
    set file [open $file]
    set ligne [gets $file]
    if {[eof $file] && ($ligne == "")} {
	close $file
	return 1
    } else {
	close $file
	return 0
    }
}

proc check {fileProp optionTrace optionSize optionTraceSize} {
    global nomRdP tpn nomCheck modif
    global cheminTemp computOption
    global romeoPath
    global parameters typePN computOption
    
    file delete $cheminTemp/mercutio.log
    set executable $romeoPath
    append executable "bin/mercutio-tctl"
    set reponse "$cheminTemp/mercutio.ans"
    set syntaxerror "$cheminTemp/mercutio.log"

    if {$parameters>=1} {
      if {$parameters==1} {
        set parameterized "-pp"
      } else {
	 if {$computOption(hull)==1} {
	     set parameterized "-pi"
	 } else {    
	     set parameterized "-pia"
	 }
      }
# pas ede trace-size dans le version actuel
#       set optT "--trace-size=$optionTraceSize"
       if {$optionTrace>0} {
          set optT "-t"
       } else {
          set optT ""
       }
    } else {
       set parameterized ""
       if {$optionTrace>0} {
          set optT "-t"
       } else {
          set optT ""
       }
    }
 
 set x 0 
 #OPTION MAXNODES
    set optmaxtnode "--max-nodes=-1"
    if {[catch {set x [format %d $computOption(node)]} erreur]} { 
        affiche "\n > error : $erreur - Stop condition --max-nodes ignored" 
    } elseif {$x>0} { 
       	set optmaxtnode "--max-nodes=$x" 
    } 
 set x 0 
   #OPTION MAXTOKEN
    set optmaxtok "--max-tokens=50000"
    if {[catch {set x [format %d $computOption(token)]} erreur]} { 
       affiche "\n > error : $erreur - Stop condition --max-tokens ignored" 
    } elseif {($x>0)&&($x>50000)} {
        set optmaxtok "--max-tokens=$x" 
    } 
 

    if {$optionSize>0} {set optS "-v"} else {set optS ""}
    if {$typePN==-2} {
        set stopwatch "-s"
    } elseif {$typePN == -1} { 
        set stopwatch "-w" 
    } else {
        set stopwatch ""
    }

    #  puts "$cheminExe$executable $nomRdP -m $fileProp"
    # cheminExe ne se termine pas par un slach
    #  puts "./mercutio $optT $optS -c $cheminExe/mercutio.que $nomRdP > $cheminExe/mercutio.ans 2> $cheminExe/mercutio.log"
    #  exec $executable $optT $optS -c $fileProp $nomRdP > $cheminExe/mercutio.ans 2> $cheminExe/mercutio.log
    affiche "\n" 
    affiche "-Invoking "
    afficheRouge "$executable"
    affiche " with options : "
    afficheBleu "$optT $optS $optmaxtok $optmaxtnode $stopwatch $parameterized -f"
    if { [catch {exec $executable $optT $optS $optmaxtok $optmaxtnode $stopwatch $parameterized -f $fileProp $nomCheck > $reponse 2> $syntaxerror} erreur] } {

      if {![file exists $syntaxerror]} {
	    set File [open $syntaxerror w]
	    puts $File "$erreur"
	    close $File
	  }
    }
    update idletasks
}

proc afficheCheck {f optionTrace optionSize} {
    global cheminTemp

    if {[emptyFile $cheminTemp/mercutio.log]} {
	set fichier "$cheminTemp/mercutio.ans"
    } else {
	set fichier "$cheminTemp/mercutio.log"
    }
    set file [open $fichier r]
    set message [read $file]
    $f insert end "$message \n" bleu
    #  if {$optionTrace + $optionSize>0}
    close $file
}


proc loadProperty {fp} {
    global property
    global nomRdP tpn
    global cheminFichiers
    global fileProperty

    afficheDialogue $fp [mc "\n-------\nLoad property ... : \n"]
    set types {
	{"tctl file"     {.tctl}      TEXT}
    }
    set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types ]
    if {[string compare $file ""]} {
	set fichier $file
	
	set file [open $fichier r]
	gets $file property
	close $file 
	set fileProperty $fichier
	afficheDialogue $fp  "$property\n"
	$fp.dialogue.fileProperty.nom config -text "$fileProperty"
    }
}
#--------------------------------- Inutile maintenant
proc savePropertyFile {fp} {
    global property
    global nomRdP tpn
    global optionTrace optionSize optionTraceSize
    global cheminFichiers
    global fileProperty

    if [string compare $fileProperty ""] {
	saveProperty $fp $fileProperty
    } else {
	afficheDialogue $fp [mc "\n-------\nUnable to save -> No file selected\n"]
    }
    $fp.dialogue.retour.syntax yview moveto 1
}
#--------------------------------- fin Inutile maintenant

proc saveProperty {fp nomFichierProperty} {
    global property
    global fileProperty

    if [string compare $nomFichierProperty ""] {
	set File [open $nomFichierProperty w]
	puts $File  "$property"
	close $File
	afficheDialogue $fp  [format [mc "\n-------\nSave property %s in %s \n"] $property $nomFichierProperty]
	return 1
    } else {
	afficheDialogue $fp [mc "\n-------\nUnable to save -> No file selected\n"]
	return 0
    }
}


proc savePropertyAs {fp} {
    global property
    global nomRdP tpn
    global optionTrace optionSize optionTraceSize
    global cheminFichiers
    global fileProperty

    set retour 0
    $fp.dialogue.retour.syntax insert end  [format [mc "\n-------\nSave property %s as ... \n"] $property]
    set types {
	{"tctl file"     {.tctl}      TEXT}
    }
    if [string compare $nomRdP($tpn) "noName.xml"] {
        set last [string first ".xml" $nomRdP($tpn)]
	if {$last>=0} {set nomProperty "[string range $nomRdP($tpn) 0 [expr $last -1]]-prop.tctl" }
	set fichier [tk_getSaveFile -filetypes $types  -title [mc "Save property as..."]\
			 -initialdir [repertoire $nomProperty] -initialfile [nomSeul $nomProperty]]
    } else {
        set fichier [tk_getSaveFile -filetypes $types -title [mc "Save property as..."] -initialdir $cheminFichiers -defaultextension .tctl]
    }
    if [string compare $fichier ""] {
	set File [open $fichier w]
	puts $File  "$property"
	close $File
	$fp.dialogue.retour.syntax insert end  "$fichier"
	set fileProperty $fichier
	$fp.dialogue.fileProperty.nom config -text "$fileProperty"
	set retour "1"
    } else {
	$fp.dialogue.retour.syntax insert end  [mc "Cancelled"]
    }
    $fp.dialogue.retour.syntax yview moveto 1
    return $retour
}

proc peutOnChecker {fp} {
    global scheduling typePN
    global nomRdP modif tpn
    global fileProperty nomCheck
    global property nomCheck
    global cheminTemp

    set retour 0
    set nomCheck "nofile"
    set retour [saveProperty $fp "$cheminTemp/mercutio.que"]

    if {$retour==1} {
	if {($modif($tpn) ==1)||(![string compare "$nomRdP($tpn)" "noName.xml"])} {
#	    set reponse [tk_messageBox -message [mc "Save net?"] -type yesno -icon question]
#	    switch -exact $reponse {
#		yes {
#		    aiguillageEnregistrer .romeo.global
#		    set nomCheck $nomRdP
#		}
#		no {
		    $fp.dialogue.retour.syntax insert end "\n"
		    $fp.dialogue.retour.syntax insert end [mc "-Petri net not saved. Checker will run with temporary file TPNCheck.xml"]
		    set nomCheck "$cheminTemp/TPNcheck.xml"
		    enregistrerTpnXml "$nomCheck"
		    set modif($tpn) 1
	    update idletasks

#		}
#	    }
	} else {set nomCheck $nomRdP($tpn) }
    }
    return $retour
}


proc checkDejaOuvert {} {
    global property

 if {[winfo exists .fenetreCheck]} {
    destroy .fenetreCheck
    checkProperty
 }

}

proc checkProperty {} {
    global nomRdP
    global francais
    global infini
    global property
    global optionTrace optionTrace optionTraceSize
    global fileProperty
    global scheduling parameters typePN
    global nbTrace

    set optionTraceSize 0
    affiche "\n"
    affiche [mc "-Opening \"on-the-fly checking\" window"]
    set fileProperty ""
    #  set property "M(1) < 2 and M(2) > 3 or M(3) <1"
    set fp .fenetreCheck
    catch {destroy $fp }
    toplevel $fp

    if {[winfo rootx .romeo] > ([winfo screenwidth .romeo]/3)} { set x 10 } else {set x [expr int([winfo screenwidth .romeo]/2)-50]}
    if {[winfo rooty .romeo] > ([winfo screenheight .romeo]/3)} { set y 20 } else {set y [expr int([winfo screenheight .romeo]/2)-10]}
    wm geometry $fp +$x+$y

    wm title $fp [mc "On-the-fly TCTL model-checking"]

    frame $fp.dialogue
    pack $fp.dialogue -side left -fill both -expand yes
    set f $fp.dialogue

    # saisie de la propriété
    frame $f.property -bd 2
    entry $f.property.saisieNom -justify left -textvariable property -relief sunken -width 60 -bg white
    label $f.property.label
    pack $f.property.saisieNom -side right -fill both -expand yes
    pack $f.property.label -side left
    $f.property.label config -text [mc "Property:"]
    pack $f.property -side top -fill both

    frame $f.fileProperty -bd 2 -relief sunken -bg white
    pack $f.fileProperty -side top -fill both
    label $f.fileProperty.lab
    pack $f.fileProperty.lab -side left
    $f.fileProperty.lab config -text [mc "File:"]
    label $f.fileProperty.nom -bg white
    pack $f.fileProperty.nom -side left -fill both
    $f.fileProperty.nom config -text ""

    frame $f.saveOpen -bd 2
    pack $f.saveOpen -side top -fill both
    button $f.saveOpen.saveas -text [mc "Save Property as..."] \
	-command "savePropertyAs $fp"
    button $f.saveOpen.save -text [mc "Save Property"] \
	-command "savePropertyFile $fp"
    button $f.saveOpen.open -text [mc "Load Property"] \
	-command "loadProperty $fp"
    pack $f.saveOpen.save $f.saveOpen.saveas $f.saveOpen.open  -side left -expand 1

    # message vers l'utilisateur
    frame $fp.dialogue.retour
    set f1 $fp.dialogue.retour
    pack $f1 -side top -fill both -expand yes

    text $f1.syntax -yscrollcommand "$f1.vscroll set" -width 70 -height 17 -bg white -wrap word
    scrollbar $f1.vscroll -command "$f1.syntax yview"
    pack $f1.syntax -side left -fill both -expand yes
    pack $f1.vscroll -side right -fill y
    

    afficheGrammaire $f1

    # affichage des indices des places
    frame $fp.indice -width 20 -height 10
    pack $fp.indice -side right -fill y
    afficheIndicePlace $fp.indice

    event add <<Echap>> <Escape>
    event add <<load>> <F1>

    bind $fp <Return> "validerCheck $fp"
    bind $fp <<Echap>> "quitterCheck $fp"
    #  bind $fp <<load>>  "source veriftpn.tcl"

    frame $f.option -relief ridge -bd 1
    pack $f.option -side top -anchor w
    #label $f.option.titre -text [mc "Options:"]
    #pack $f.option.titre -side top -anchor w

    frame $f.option.gauche
    pack $f.option.gauche -side left -anchor w

    set nbTrace 1
    frame $f.option.gauche.trace
    pack $f.option.gauche.trace -side top -anchor w -expand yes

# au lieu de  if {$parameters} je mets ca car l'option tracesize n'est pas disponible pour le moàment
    if {$parameters==243} {
        frame $f.option.gauche.traceSize
        pack $f.option.gauche.traceSize -side top -pady 2 -anchor w
	entry  $f.option.gauche.traceSize.saisie -justify left -textvariable optionTraceSize -relief sunken -width 10 -bg white 
	pack  $f.option.gauche.traceSize.saisie -side left
        label $f.option.gauche.traceSize.label -text [mc ": maximum trace size (none if 0)"]       	
        pack $f.option.gauche.traceSize.label -side left
    } else {
        checkbutton $f.option.gauche.trace.yesno -text "[mc "Give a trace?"]" -variable optionTrace -selectcolor red
        #entry $f.option.gauche.trace.nb -justify left -textvariable nbTrace -relief sunken -width 5 -bg white
        pack $f.option.gauche.trace.yesno -side left -anchor w -expand yes
        #pack $f.option.gauche.trace.nb -side right -anchor w -expand yes
    }

    #checkbutton $f.option.gauche.size -text [mc "Give graph size (states - zones)"] -variable optionSize -selectcolor red
    #pack $f.option.gauche.size -side top -anchor w -expand yes

    frame $f.buttons -bd 2
    button $f.buttons.annuler -text [mc "Close"] -command  "quitterCheck $fp"
    button $f.buttons.accepter -default active -text [mc "Check property"] \
	-command "validerCheck $fp"
    pack $f.buttons -side bottom -fill both
    pack $f.buttons.accepter $f.buttons.annuler  -side left -expand 1

    #++++++ procedures internes à check property
    proc quitterCheck {fp} {
	destroy $fp
	affiche "\n"
	affiche [mc "-\"On-the-fly checking\" window closed"]
    }
    proc validerCheck {fp} {
	global property nomCheck
	global nomRdP modif tpn
	global optionTrace optionSize nbTrace optionTraceSize
	global fileProperty
	global cheminTemp
	global scheduling typePN


     set erreur [TCTL $property]

     if {$erreur == ""} {

	if {$optionTrace == 0} {set nbTrace 0}
	if {[peutOnChecker $fp]==1} {
            update idletasks
	    $fp.dialogue.retour.syntax insert end  "\n-------\n"
#	    if {$scheduling==1} {
#		$fp.dialogue.retour.syntax insert end  [mc "Cannot check property on Scheduling TPN (SETPN). \nProperty will be checked on the underlying TPN of the SETPN:\n"] bleu
#	    }
	    $fp.dialogue.retour.syntax insert end  [format [mc "Checking property %s on TPN: \"%s\"\n"] $property $nomCheck]
	    $fp.dialogue.retour.syntax insert end  [mc "Waiting for response...\n"] rouge
	    update idletasks
            if {![entier $optionTraceSize]} { set optionTraceSize 0}
	    check "$cheminTemp/mercutio.que"  $nbTrace $optionSize $optionTraceSize
	    file delete $cheminTemp/mercutio.que
	    afficheCheck $fp.dialogue.retour.syntax $nbTrace $optionSize 
	}
	$fp.dialogue.retour.syntax yview moveto 1
	#   destroy $f
     } else {
	$fp.dialogue.retour.syntax insert end  "\n-------\n"
	$fp.dialogue.retour.syntax insert end  "Syntax error in property $property\n"
	$fp.dialogue.retour.syntax insert end  "$erreur" bleu
	$fp.dialogue.retour.syntax yview moveto 1
        update idletasks

     }
    }
    
}

#++++++ procedures internes à check property



proc afficheIndicePlace {fi} {
    global tabPlace tpn
    global fin
    global ok
    global infini

    text $fi.text -yscrollcommand "$fi.vscroll set" -setgrid true \
	-width 20 -height 8
    scrollbar $fi.vscroll -command "$fi.text yview"
    # -xscrollcommand "$fi.hscroll set"
    # scrollbar $fi.hscroll -orient horiz -command "$fi.text xview"


    pack $fi.vscroll -side right -fill y
    pack $fi.text -expand yes -fill both
    # pack $fi.hscroll -side bottom -fill x

    $fi.text tag configure rouge -foreground red
    $fi.text tag configure surgris -background #a0b7ce
    $fi.text tag configure souligne -underline on


    $fi.text insert end "  PLACE             \n" souligne
    $fi.text insert end "Index " surgris
    $fi.text insert end "  \"label\" \n" rouge


    # place par place
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
	if {$tabPlace($tpn,$i,statut)==$ok} {
	    $fi.text insert end "$i " surgris
	    $fi.text insert end "  \"$tabPlace($tpn,$i,label,nom)\"\n" rouge
	}
    }
}

#--------------------------------------------------------------------------------------------
						       
# TCTL appelle expressionGMEC qui appelle GMEC qui appelle termeGMEC					     

#--------------------------------------------------------------------------------------------
proc termeGmec {chaine} {
    global tabPlace ok fin tpn
    global parameters

# optype = 0 pour rien, 1 pour operateur, 2 pour operande
set optype 0
set plusmoins 0
set erreur ""

 while {([finLigne $chaine]==0)&&($erreur=="")} {
      set chaine [gotonext $chaine]
      set sep [nextSeparateur $chaine [list + - * " " M( m( ( deadlock bounded] ]  
# )))
      if {$sep > 0} {
         set plusmoins 0
	 if {$optype == 2} {
            set erreur "$chaine -> Operator expected"
         } else {
 	   set optype 2
           set erreur [verifOperande [string range $chaine 0 [expr $sep -1] ]]
           if {[finLigne $chaine]==0} {
             set chaine [gotonext [string range $chaine $sep [string length $chaine] ]]
	   }
         }
      } elseif {$sep ==0} {
          if {[carDansListe [nextCar $chaine]  [list M m]]} {
 	      if {$optype == 2} {
                  set erreur "$chaine -> Operator expected"
              } else {
		  set plusmoins 0
		  set optype 2
		  set fermePar [indexFinTerme [supNextCar $chaine]]
		  set erreur [verifMarking  [string range $chaine 0 [expr $fermePar+1] ]]    
		  set chaine [gotonext [string range $chaine [expr $fermePar+2] [string length $chaine]  ] ] 
              }
          } elseif {[carDansListe [nextCar $chaine]  [list + -]]} {
	      set optype 1
              incr plusmoins
	      if {$plusmoins < 2} {
                 set chaine [gotonext [supNextCar $chaine]]
		 if {[finLigne $chaine]} {set erreur "-> Bad expression"}
              } else {  set erreur "$chaine -> Bad expression"}
          } elseif {[nextCar $chaine]=="("} {
 		 if {$optype == 2} {
		     set erreur "$chaine -> Operator expected"
		 } else {
		     set plusmoins 0
		     set optype 2
		     set fermePar [indexFinTerme $chaine] 
		     if {$fermePar >=0} {
			 # ou etudie le terme en retirant les parentheses
			 set erreur [termeGmec [gotonext [string range $chaine 1 [expr $fermePar-1] ]] ]   
			 # et on continue avec la suite
			 set chaine [gotonext [string range $chaine [expr $fermePar+1] [string length $chaine]  ] ] 
		     } else {set erreur "$chaine -> missing close-brace"}
		 }
	  } elseif {[nextCar $chaine]=="*"} {
	      set plusmoins 0
	      if {$optype == 1} {
		  set erreur "$chaine -> Bad expression"
	      } else {
		 set optype 1
                 set chaine [gotonext [supNextCar $chaine]]
		 if {[finLigne $chaine]} {set erreur "$chaine -> Bad expression"}
	     }
	  } else {
# normalement inutil
            set chaine ""
          }
     } else {
          if {[finLigne $chaine]==1} {
            set erreur "$chaine -> Bad expression"
	  } else {
	      if {$optype == 2} {
                 set erreur "$chaine -> Operator expected"
              } else {
		  set erreur [verifOperande $chaine]
		  set chaine "" 
	      }
          }
      }
  }
 return $erreur
 }
#--------------------------------------------------------------------------------------------
proc GMEC {chaine} {
    global tabPlace tpn ok fin
    global parameters

    set gauche ""
    set droite ""
    set erreur ""
    set sep [nextSeparateur $chaine [list > < = bounded deadlock]]
    if {$sep > 0} {
	if {[nextSeparateur $chaine [list >= <=]]>0} {
	    set delta 2	    
	} else {
	    set delta 1
	}
	set gauche [gotonext [gotoprevious [string range $chaine 0 [expr $sep -1] ]]]
	set droite [gotonext [gotoprevious [string range $chaine [expr $sep+$delta] [string length $chaine] ]]]
    } else { set erreur "missing operator in GMEC $chaine" }


    if {[nbOccurence $gauche "("]-[nbOccurence $gauche ")"]!=[nbOccurence $droite ")"]-[nbOccurence $droite "("]} {
      set erreur "missing close-brace or extra characters after close-brace"
    } else {
	while {([nbOccurence $gauche "("]>[nbOccurence $gauche ")"]) && ($erreur == "")} {
	    if {([nextCar $gauche]=="(") && ([lastCar $droite]==")")} {
		set gauche  [gotonext [supNextCar $gauche]]
                set droite [gotoprevious [supLastCar $droite]]
	    } else { set erreur  "missing close-brace or extra characters after close-brace"}
	}
    }
    if {[finLigne $droite]||[finLigne $gauche]} {set erreur "-> Bad expression"}
    if {$erreur == ""} {
	set erreur [termeGmec $gauche]
    } 
    if {$erreur == ""} {
	set erreur [termeGmec $droite]
    } 


   return $erreur
}

#--------------------------------------------------------------------------------------------
proc expressionGMEC {chaine} {


set erreur ""
set optype 1

# optype = 0 pour rien, 1 pour operateurs and or =>, 2 pour GMEC, 3 pour not, (on considère que deadlock bounded est GMEC)


 while {([finLigne $chaine]==0)&&($erreur=="")} {
     set chaine [gotonext $chaine]


# ICI c'est pour autoriser EF[0,100]( M(3)+ 2*( M(5) - 2*M(2) )  > 0 )
# On l'enleve car le parser de mercutio ne prend pas ca en compte
#     set sep [nextSeparateurSaufM $chaine [list not => and or AND OR] ]  
#     if {$sep <0 } {
#        set erreur [GMEC $chaine]
#        set chaine ""
#     } else {
#      }
#la fermeture est à mettre tout à la fin avant le return



	 set sep [nextSeparateurSaufM $chaine [list ( not => NOT and or AND OR bounded deadlock] ]  
# )))

	 if {$sep > 0} {
	     if {$optype == 2} {
		 set erreur "$chaine -> Operator (=>,and,or) expected"
	     } else {
		 set optype 2
		 set erreur [GMEC [gotonext [string range $chaine 0 [expr $sep -1] ]]]
		 if {[finLigne $chaine]==0} {
		     set chaine [gotonext [string range $chaine $sep [string length $chaine] ]]
		 }
	     }
	 } elseif {$sep ==0} {
	     if {[nextSeparateur $chaine [list deadlock] ]==0} {
 		 if {$optype == 2} {
		     set erreur "$chaine -> Operator (=>,not,and,or) expected"
		 } else {
		     set optype 2
		     set chaine [gotonext [string range $chaine 8 [string length $chaine] ]]
		 }
	     } elseif {[nextSeparateur $chaine [list deadlock bounded] ]==0} {
 		 if {$optype == 2} {
		     set erreur "$chaine -> Operator (=>,not,and,or) expected"
		 } else {
		     set optype 2
		     set chaine [supNextExpression $chaine "bounded"]
		     if {[entier [entreParentheses $chaine]]} {
			 set chaine [supNextExpression $chaine ")"]
		     } else {
			 set erreur "[entreParentheses $chaine] -> (integer) expected"
		     }
		 }
	     } elseif {[nextSeparateur $chaine [list => and or AND OR] ]==0} {
		 if {($optype==1)} {
		     set erreur "$chaine -> GMEC or deadlock or bounded(k) expected"
		 } else {
		     set optype 1
		     if {([nextCar $chaine]=="o")||([nextCar $chaine]=="O")||([nextCar $chaine]=="=")} {
			 set chaine [gotonext [string range $chaine 2 [string length $chaine] ]]
		     } elseif {
			       ([nextCar $chaine]=="a")||([nextCar $chaine]=="A")} {set chaine [gotonext [string range $chaine 3 [string length $chaine] ]]
		     }
		     if {[finLigne $chaine]} {set erreur "-> GMEC expected"}
		 }
	     } elseif {[nextSeparateur $chaine [list not NOT] ]==0} {
		 if {($optype!=1)} {
		     set erreur "$chaine -> Operator (=>,not,and,or) expected"
		 } else {
		     set optype 3
		     set chaine [gotonext [string range $chaine 3 [string length $chaine] ]]
		     if {[finLigne $chaine]} {set erreur "-> GMEC expected"}
		 }	     
	     } elseif {[nextCar $chaine]=="("} {
 		 if {$optype == 2} {
		     set erreur "$chaine -> Operator (=>,not,and,or) expected"
		 } else {
		     set optype 2
		     set fermePar [indexFinTerme $chaine] 
		     if {$fermePar >=0} {
			 # ou etudie le terme en retirant les parentheses
			 set erreur [expressionGMEC [gotonext [string range $chaine 1 [expr $fermePar-1] ]] ]   
			 # et on continue avec la suite
			 set chaine [gotonext [string range $chaine [expr $fermePar+1] [string length $chaine]  ] ] 
		     } else {set erreur "$chaine -> missing close-brace"}
		 }
	     }
	 } else {
	     if {[finLigne $chaine]==1} {
		 set erreur "$chaine -> Bad expression"
	     } else {
		 if {$optype == 2} {
		     set erreur "$chaine -> Operator (=>,not,and,or) expected"
		 } else {
		     set erreur [GMEC [gotonext  $chaine]]
		     set chaine "" 
		 }
	     }
	 }
      }
     
 return $erreur
 }

#--------------------------------------------------------------------------------------------
proc TCTL {chaine} {
    global tabPlace tpn ok fin
    global parameters
    set erreur ""
    set chaine [gotonext $chaine]
    if {[nextSeparateur $chaine [list "E(" "EF" "A(" "AF" "EG" "AG" ]]==0} { 
	set quantif [string range $chaine 0 1]
#	set sep [nextSeparateur $chaine [list "E(" "EF" "A(" "AF" "EG" "AG" ]]
	switch $quantif {
	    "E(" {
	          set fermePar [indexFinTerme [supNextCar $chaine]]
		  set erreur [expressionGMEC  [string range $chaine 1 [expr $fermePar+1] ]]    
		  set chaine [gotonext [string range $chaine [expr $fermePar+2] [string length $chaine]  ] ] 
		  if {$erreur == ""} {
		      set erreur [until $chaine]
		  }
	    }
	    "A(" {
	          set fermePar [indexFinTerme [supNextCar $chaine]]
		  set erreur [expressionGMEC  [string range $chaine 1 [expr $fermePar+1] ]]    
		  set chaine [gotonext [string range $chaine [expr $fermePar+2] [string length $chaine]  ] ] 
		  if {$erreur == ""} {
		      set erreur [until $chaine]
		  }
	    }
	    default {
		  set erreur [afterUntil  [string range $chaine 2 [string length $chaine] ]]    
	    }
        }
    } elseif {[string first "-->" $chaine]>0} {
	set erreur  [expressionGMEC [string range $chaine 0 [expr [string first "-->" $chaine]-1] ]]
       if {$erreur == ""} {
	   set erreur [afterUntil [string range $chaine [expr [string first "-->" $chaine]+2] [string length $chaine]  ]]
       }

    } else {
	set erreur "$chaine -> Bad expression"
    }
   return $erreur
}

#--------------------------------------------------------------------------------------------
proc until {chaine} {

set erreur ""

    if {[nextCar $chaine]!="U"} {
      set erreur "$chaine -> U expected"
    } else {
	set erreur [afterUntil [supNextCar $chaine]]
    }
return $erreur
}

proc afterUntil {chaine} {
    global parameters

    set erreur ""
    set chaine [gotonext $chaine]
	set interval [nextExpression [supNextExpression $chaine "\["]  "\]"]
	set suite [supNextExpression $chaine "\]"]
	if {$parameters==0} {
	    set nb1 [nextExpression $interval ","]
	    set nb2 [supNextExpression $interval ","]
	    if {!([entier $nb1] && ([entier $nb2] || ([sansEspace $nb2] =="inf") ))} {          
		set erreur "\[$nb1,$nb2\] -> integer or inf expected"
	    } 
	}
	if {$erreur == ""} {
	    set erreur [expressionGMEC $suite]
	}
    
   return $erreur
}

proc verifOperande {chaine} {
# todo verifier que c'est bien une operande : entier ou parametre

    if {![entier $chaine]} { 
	set erreur "$chaine -> integer expected"
    } else { 
	set erreur ""
    }
return $erreur
}

proc verifMarking {chaine} {

   global tabPlace tpn ok fin
   global parameters

set erreur ""
    # on commence par calculer l'indice max des places
    for {set iMax 1} {$tabPlace($tpn,$iMax,statut)!=$fin} {incr iMax} {}

   # extraire indice : M(indice)
    set indice [nextExpression [supNextExpression $chaine "("]  ")"]
    if {(![entier $indice]) || ($indice<=0) || ($indice>=$iMax) || ($tabPlace($tpn,$indice,statut)!=$ok)} {
	      set erreur "M($indice) error ->  $indice : place index expected"
    }
return $erreur
}


proc entreParentheses {chaine} {
   set indexCar 0
   set openClose 1

   set resul ""
   if {[nextCar $chaine]== "("} { 
       # retirer l'ouverture de parenthese
       set chaine [supNextCar $chaine] 
       if {[finLigne $chaine] ==0} {
	   set firstPosition [string first ")" $chaine]
	   if {$firstPosition >=0} {
	       set resul [string range $chaine 0 [expr $firstPosition -1] ]
	   } else { 
	       set resul "missing open or close-brace" 
	   }
       }
   } else {
      set resul "missing parenthesis" 
   }

   return $resul
}


proc indexFinTerme {chaine} {
   set indexCar 0
   set openClose 1

 # retirer l'ouverture de parenthese
   set chaine [supNextCar $chaine] 
   while {([finLigne $chaine]==0)&&($openClose>0)} {
       if {[nextCar $chaine] == ")"} {
          set openClose [expr $openClose-1]
       } elseif {[nextCar $chaine] == "("} {
          incr openClose
       }
       set chaine [supNextCar $chaine]
       incr indexCar
   }

   if {([finLigne $chaine]==1)&&($chaine>0)} {
      return -1
   } else { return $indexCar}

}
						       

#--------------------------------------------------------------------------------------------

proc nbOccurence {chaine leCaractere} {
   set nombre 0
   while {([finLigne $chaine]==0)} {
     if {[nextCar $chaine] == $leCaractere} {incr nombre}
     set chaine [supNextCar $chaine]
   }
   return $nombre
}

proc xmlProperty {indice comp val} {

    switch $comp {
	>  { set op "Greater" }
	<  { set op "Lower"  }
	>= { set op "GreaterOrEqual" }
	<= { set op "LowerOrEqual"   }
	=  { set op "Equal"   }
	default {
	    set op ERREUR
	    #     puts $comp
	}
    }
    return "    <place id=\"$indice\" op=\"$op\" value=\"$val\"\/>\n"
}


proc supNextExpression {chaine separateur} {
    set resul ""
    if {[finLigne $chaine] ==0} {
	set firstPosition [string first $separateur $chaine]
	if {$firstPosition >=0} {set resul [string range $chaine [expr $firstPosition + [string length $separateur]] [string length $chaine] ]
	} else { set resul "" }
    }
    return $resul
}

proc nextExpression {chaine separateur} {
    set resul ""
    if {[finLigne $chaine] ==0} {
	set firstPosition [string first $separateur $chaine]
	if {$firstPosition >=0} {set resul [string range $chaine 0 [expr $firstPosition -1] ]
	} else { set resul $chaine }
    }
    return $resul
}

proc finLigne {chaine} {
    set fin 1
    for {set i 0} {[string index $chaine $i] != ""}   {incr i} {
	if {[string compare [string index $chaine $i] " "]!=0} {set fin 0}
    }
    return $fin
}


proc entier {chaine} {
    set resul 1
    if {[string compare $chaine ""]==0} {set resul 0}
    while {[string compare $chaine ""]} {
	if {[nextCar $chaine] == " "}{set chaine [supNextCar $chaine]}
	if {[string compare $chaine ""]==0} {set resul 0}
    }
    while {[string compare $chaine ""]} {
	if {[string first [nextCar $chaine] "0123456789"]<0} {set resul 0}
	set chaine [supNextCar $chaine]
    }
    return $resul
}

proc flottant {chaine} {
    set resul 1
    if {[string compare $chaine ""]==0} {set resul 0}
    while {[string compare $chaine ""]} {
	if {[string first [nextCar $chaine] "0123456789."]<0} {set resul 0}
	set chaine [supNextCar $chaine]
    }
    return $resul
}


proc nextCar {chaine} {

    if {[string compare $chaine ""]} {
	return [string index $chaine 0]
    } else { return ""}

}

proc supNextCar {chaine} {
    if {[string compare $chaine ""]} {
	return [string range $chaine 1 [string length $chaine] ]
    } else {  return ""}
}

proc lastCar {chaine} {

    if {[string compare $chaine ""]} {
	return [string index $chaine  [expr [string length $chaine]-1]]
    } else { return ""}

}
proc supLastCar {chaine} {
    if {[string compare $chaine ""]} {
	return [string range $chaine 0 [expr [string length $chaine]-2]]
    } else {  return ""}
}

#string index string charIndex
#Returns the charIndex'th character of the string argument.  A charIndex of 0 corresponds to the first character of the string. If charIndex is less than 0 or greater than or equal to the length of the string then an empty string is returned.
#[string last "/" $fichier]
#[string compare $nomRdP "noName.xml"]
#set nomProcedure [string range $fichier [expr $dernierSlach + 1] [string length $fichier] ]
#set espace [string first "/" $phrase]


# A SUPPRIMER
proc supNextMot {chaine} {
    set chaine [gotonext $chaine]
    set resul ""
    if {[finLigne $chaine] ==0} {
	set firstEspace [minPlus [minPlus [string first "!" $chaine] [string first ">" $chaine]] \
			     [minPlus [minPlus [string first " " $chaine] [string first ";" $chaine]] \
                                  [minPlus [string first ")" $chaine] [string first "(" $chaine]] ] ]
	if {$firstEspace>=0} {set resul [string range $chaine [expr $firstEspace] [string length $chaine] ]
	} else { set resul $chaine }
    }
    return [gotonext $resul]
}



# enleve les espaces en debut de chaine
proc gotonext {chaine} {
    set x 0
    while {[string index $chaine $x] == " "} {incr x}
    return [string range $chaine $x [string length $chaine] ]
}

proc gotoprevious {chaine} {
    set x  [expr [string length $chaine] - 1]
    while {[string index $chaine $x] == " "} {set x [expr $x-1]}
    return [string range $chaine 0 $x]
}



proc nextMot {chaine} {
    set resul ""
    set chaine [gotonext $chaine]
    if {[finLigne $chaine] ==0} {
	set firstEspace [minPlus [minPlus [string first "!" $chaine] [string first ">" $chaine]] \
			     [minPlus [minPlus [string first " " $chaine] [string first ";" $chaine]] \
                                  [minPlus [string first ")" $chaine] [string first "(" $chaine]] ] ]
	if {$firstEspace>=0} {set resul [string range $chaine 0 [expr $firstEspace -1] ]
	} else { set resul $chaine }
    }
    return $resul
}

proc minPlus {a b} {
    if {$a<0} {set a $b}
    if {$b<0} {set b $a}
    if {$a <$b} {return $a} else {return $b}
}


#************************************************************************************
# Verification syntaxique des contraintes

proc carDansListe {caractere liste} {
    set reponse 0

    for {set i 0} {$i<[llength $liste]} {incr i} {
	if {$caractere == [lindex $liste $i]} {set reponse 1}
    }
    return $reponse
}

proc nextSeparateur {chaine listeSeparateur} {
    set theFirst -1
    for {set i 0} {$i<[llength $listeSeparateur]} {incr i} {
	set theFirst [minPlus $theFirst [string first [lindex $listeSeparateur $i] $chaine]]
    }
 #   puts $theFirst
    return $theFirst
}

proc nextSeparateurSaufM {chaine listeSeparateur} {
    set chaine [string map {M( MM m( mm} $chaine]
   return  [nextSeparateur $chaine $listeSeparateur]
}


proc verifSyntaxeParametre {chaine} {
set erreur ""
set operande1 ""
set operateur ""
set plusmoins 0

  set chaine [gotonext $chaine]
  while {([finLigne $chaine]==0)&&($erreur=="")} {
      set sep [nextSeparateur $chaine [list + - * / " "]]
      if {$sep > 0} {
         set plusmoins 0
         set operande1 [string range $chaine 0 [expr $sep -1] ]
         if {[finLigne $chaine]==0} {
           set chaine [gotonext [string range $chaine $sep [string length $chaine] ]]
           set operateur [nextCar $chaine]
	   if {[carDansListe $operateur  [list + - * /]]} {
               set chaine [gotonext [supNextCar $chaine]]
 	       if {[finLigne $chaine]} {set erreur "$operande1$operateur... Error -> parameter or integer expected"}
	   } elseif {![finLigne [gotonext $chaine]]} {
	      set erreur "$operande1... Error -> Operator expected"
           }
	 }
      } elseif {$sep ==0} {
          if {[carDansListe [nextCar $chaine]  [list + -]]} {
             incr plusmoins
	      if {$plusmoins < 2} {
                 set chaine [gotonext [supNextCar $chaine]]
              } else {  set erreur "$chaine Bad expression"}
          } else {
             set erreur "$chaine... Error -> parameter or integer expected"
	  }
      } else {
          if {[finLigne $chaine]==1} {
            set erreur "$chaine Bad expression"
	  } else {set chaine "" }
      }
  }
 return $erreur 
}


proc verifSyntaxeContrainte {chaine} {
set erreur ""
set operande1 ""
set operateur ""
set plusmoins 0

  while {([finLigne $chaine]==0)&&($erreur=="")} {
      set chaine [gotonext $chaine]
      set sep [nextSeparateur $chaine [list + - * / > < = " "]]
      if {$sep > 0} {
         set plusmoins 0
         set operande1 [string range $chaine 0 [expr $sep -1] ]
         if {[finLigne $chaine]==0} {
           set chaine [gotonext [string range $chaine $sep [string length $chaine] ]]
           set operateur [nextCar $chaine]

	   if {[carDansListe $operateur  [list + - * / = > <]]} {
               set chaine  [supNextCar $chaine]
               if {[carDansListe $operateur  [list > <]]&&![finLigne $chaine]} {
		   if {[nextCar $chaine]== "="} {
		       set chaine [supNextCar $chaine]
                       set operateur "$operateur\="
                   }
	       }

 	       if {[finLigne $chaine]} {set erreur "$operande1$operateur... -> parameter or integer expected"}
	   } elseif {![finLigne [gotonext $chaine]]} {
	      set erreur "$operande1... -> Operator expected"
           }
	 }
      } elseif {$sep ==0} {
          if {[carDansListe $operateur[nextCar $chaine]  [list + -]]} {
             incr plusmoins
	      if {$plusmoins < 2} {
                 set chaine [gotonext [supNextCar $chaine]]
              } else {  set erreur "$chaine -> Bad expression"}
          } else {
             set erreur "$chaine... -> parameter or integer expected"
	  }
      } else {
          if {[finLigne $chaine]==1} {
            set erreur "$chaine -> Bad expression"
	  } else {set chaine "" }
      }
  }
# puts $erreur
 return $erreur
}


proc afficheGrammaire {f1} {
    global scheduling parameters typePN


    $f1.syntax tag configure rouge -foreground red
    $f1.syntax tag configure bleu -foreground darkblue
    $f1.syntax tag configure surgris -background #a0b7ce

    $f1.syntax insert end "GMEC" surgris
    $f1.syntax insert end " = a * M(i) \{+,-\} b * M(j) \{<,<=, >, >=, =\} k \| deadlock \| bounded(k) \| p and q \| p or q \| p => q \| not p \n" bleu
    $f1.syntax insert end [mc "M: keyword (marking); deadlock, bounded: keywords; i,j:place index; a,b,k :integer ; *, +, -, and, or, =>, not: usual operator ; p,q: GMEC \n \n"]

    # typePN -> -1 : stopwatch ;   -2 scheduling ; 1 t-tpn ; 2 p-tpn

    if {$typePN == 2} {
        $f1.syntax insert end "pTPN-CTL" surgris
	$f1.syntax insert end " = E(p)U(q) \| A(p)U(q) \| EF(p) \| AF(p) \| EG(p) \| AG(p) \| EF(p) \| (p)-->(q) \| phi and psi \| phi or psi \n" bleu
        $f1.syntax insert end [mc "p,q: GMEC; phi, psi : pTPN-CTL; U: until; E: exists; A: forall; F: eventually; G: always; --> : response. \n"]

    } else {
	if {$parameters>=1} {
	    $f1.syntax insert end "ParamTPN-PTCTL" surgris
	    $f1.syntax insert end " = E(p)U\[a,b\](q) \| A(p)U\[a,b\](q) \| EF\[a,b\](p) \| AF\[a,b\](p) \| EG\[a,b\](p) \| AG\[a,b\](p) \| EF\[a,b\](p) \| (p)-->\[0,b\](q)  \n" bleu
	    $f1.syntax insert end [mc "p,q: GMEC; U: until; E: exists; A: forall; F: eventually; G: always; --> : response; a: parameter or integer; b parameter or integer or \{inf\} \n"]
	} else {
	    $f1.syntax insert end "TPN-TCTL" surgris
	    $f1.syntax insert end " = E(p)U\[a,b\](q) \| A(p)U\[a,b\](q) \| EF\[a,b\](p) \| AF\[a,b\](p) \| EG\[a,b\](p) \| AG\[a,b\](p) \| EF\[a,b\](p) \| (p)-->\[0,b\](q)  \n" bleu
	    $f1.syntax insert end [mc "p,q: GMEC; U: until; E: exists; A: forall; F: eventually; G: always; --> : response; a: integer; b integer or \{inf\} \n"]
	}
	# T-TPN et parametric :
	$f1.syntax insert end [mc "\nThe syntax (p)-->\[0,b\](q) denotes a leads to property meaning AG( (p) imply AE\[0,b\](q) ). E.g. (p)-->\[0,b\] (q) holds if and only if whenever p holds eventually q will hold as well in \[0,b\] time units. \n \n"]

	$f1.syntax insert end [mc "Example 1"] surgris
	$f1.syntax insert end " : EF\[0,10\](M(2)-M(3)>0)" bleu
	$f1.syntax insert end [mc " means that a state with a marking M such that M(2)-M(3)>0 is reachable in less than 10 time units.\n"]
	$f1.syntax insert end [mc "Example 2"] surgris
	$f1.syntax insert end " : AG\[0,inf\](not deadlock) and bounded(3)" bleu
	$f1.syntax insert end [mc " means that the TPN has no deadlock and is 3-bounded."]
    }
    $f1.syntax insert end "\n --------------------\n \n"
#    if {$scheduling} {
#	$f1.syntax insert end [mc "Scheduling mode is selected"] surgris
#	$f1.syntax insert end "\n\n       -> "
#	$f1.syntax insert end [mc "Property will be checked on underlying TPN"] rouge
#	$f1.syntax insert end "\n          ------------------------------------------\n " bleu
#    }

}