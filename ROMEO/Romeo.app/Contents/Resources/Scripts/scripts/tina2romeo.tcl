proc importFromOsate {c} {
   global nomRdP
   global modif
   global cheminFichiers
   global francais
   global tabPlace
   global tabTransition
   global nbProcesseur
   global fin ok destroy
   global simulatorOn
   global romeoPath

    set executable $romeoPath
    append executable "bin/osate2romeo.exe"
 
 if {[file exists $executable]} {       
  
   if {$simulatorOn} {    
     affiche [mc "-Warning: Not allowed - Quit simulator first"]
   } else {
     set types {
      {{OSATE input file}     {.aaxl}  TEXT}
       }

     if {[fautIlSauver]==1} {
       set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types -title "Import from OSATE (.aaxl)..."]
       if {[string compare $file ""]} {
         #*** souris en sablier
         $c configure -cursor watch
         update

	     affiche "\n"
	     affiche " -Importing $file from OSATE..."
	     exec $executable $file 
         set last [string first ".aaxl" $file] 
         if {$last>=0} {
           set nomRdP [string range $file 0 [expr $last -1]]  
           set ext ".xml"
           set nomRdP $nomRdP$ext
           #*** souris normal  (plus en sablier)***
           $c configure -cursor arrow
           update
           ouvrirPointXML .romeo.global $c 0 $nomRdP
      }
     }
    }
   } 
  }	else { affiche "-Unable to import file - program osate2romeo not found!" }
}  




proc export2tina {c} {

global nomRdP  tpn
global modif
global cheminFichiers
global francais

   set last [string first ".xml" $nomRdP($tpn)] 
    if {$last>=0} {
         set nomTina [string range $nomRdP($tpn) 0 [expr $last -1]]  
    } else {
         set nomTina $nomRdP($tpn)
    }

    set types {
    {"TINA file"     {.ndr}      TEXT}
       }
       
    set ext ".ndr"

    if [string compare $nomTina "noName.xml"] {
        set fichier [tk_getSaveFile -filetypes $types  -title [mc "Export TPN to TINA as (file.ndr)"]\
	 -initialdir [repertoire $nomTina] -initialfile [nomSeul $nomTina$ext] -defaultextension .ndr]
    } else {
        set fichier [tk_getSaveFile -filetypes $types  -title [mc "Export TPN to TINA as (file.ndr)"]\
        -initialdir $cheminFichiers -initialfile $nomTina$ext -defaultextension .ndr]
    }

    if [string compare $fichier ""] {
       romeo2tina $fichier
    }
}


proc importFromTina {c} {
   global nomRdP
   global modif tpn
   global cheminFichiers
   global francais
   global tabPlace
   global tabTransition
   global nbProcesseur
   global fin ok destroy
   global simulatorOn
   global tabConstraint
   global nbConstraints
   
 if {$simulatorOn} {    
   affiche [mc "-Warning: Not allowed - Quit simulator first"]
 } else {
   set types {
    {{TINA input file}     {.ndr}  TEXT}
       }
#  queCreerDetruirePTLPTF $c 0 0 0 0 0 0 0 0
  if {[fautIlSauver]==1} {
   set file [tk_getOpenFile -initialdir $cheminFichiers -filetypes $types -title [mc "Import from TINA..."]]
    if {[string compare $file ""]} {
       #*** souris en sablier
       $c configure -cursor watch
       update

       set last [string first ".ndr" $file] 
       if {$last>=0} {
          set nomRdP [string range $file 0 [expr $last -1]]  
          tina2romeo $file $c
          set modif($tpn) 1
          set ext ".xml"
          set nomRdP $nomRdP$ext
#         .romeo.ligneDuBas.indication.nomRdp config -text [format [mc "TPN: %s"] $nomRdP]
       }
       #*** souris normal  (plus en sablier)***
       $c configure -cursor arrow
       update

    }
  }
 } 
}  


proc tina2romeo {fichier c} {
   global nomRdP
   global modif
   global home
   global cheminFichiers
   global francais
   global tabPlace
   global tabTransition
   global nbProcesseur
   global fin ok destroy
   global modif
   global maxX
   global maxY
   global infini
   global couleur
   global tabConstraint
   global nbConstraints
   
     affiche "\n"
#     affiche [format [mc "-Importing PN from TINA file: %s ..."] $fichier]
     affiche [mc "-Importing PN from TINA file: "]
     afficheBleu $fichier
     affiche " ..."

     set tabPlace($tpn,1,statut) $fin
     set tabTransition($tpn,1,statut) $fin
     set nbProcesseur 0
     set tabConstraint(0) ""
     set nbConstraints 1

     set file [open $fichier r]
#     set fileTina [read $file]
    while {([eof $file] <1)} {
       gets $file ligne     
       set balise [nextExpression $ligne " "]
       set ligne [supNextExpression $ligne " "]
       switch $balise { 
          p { 
             set x [nextExpression $ligne " "]
             set ligne [supNextExpression $ligne " "]   
             set y [nextExpression $ligne " "]
             set ligne [supNextExpression $ligne " "] 
             set label [nextExpression $ligne " "]
             set indice [supNextExpression $label "p"]
             set ligne [supNextExpression $ligne " "]
             set  mark [nextExpression $ligne " "]
             insererPlace $indice
             set tabPlace($tpn,$indice,statut) $ok
             set tabPlace($tpn,$indice,label,nom) $label
             set tabPlace($tpn,$indice,label,dx) 10
             set tabPlace($tpn,$indice,label,dy) 10
             set tabPlace($tpn,$indice,processeur) 0
             set tabPlace($tpn,$indice,priorite) 0
             set tabPlace($tpn,$indice,jeton) $mark
             set tabPlace($tpn,$indice,xy,x) $x
             set tabPlace($tpn,$indice,xy,y) $y
          }
          t {
             set x [nextExpression $ligne " "]
             set ligne [supNextExpression $ligne " "]   
             set y [nextExpression $ligne " "]
             set ligne [supNextExpression $ligne " "] 
             set label [nextExpression $ligne " "]
             set indice [supNextExpression $label "t"]
             set ligne [supNextExpression $ligne " "]
             set alpha [nextExpression $ligne " "]
             set ligne [supNextExpression $ligne " "]
             set beta [nextExpression $ligne " "]
             if {$beta=="w"} {set beta $infini}
             insererTransition $indice
             set tabTransition($tpn,$indice,statut) $ok
             set tabTransition($tpn,$indice,dmin) $alpha
	         set tabTransition($tpn,$indice,dmax) $beta
             set tabTransition($tpn,$indice,label,nom) $label
             set tabTransition($tpn,$indice,label,dx) 10
             set tabTransition($tpn,$indice,label,dy) 10
             set tabTransition($tpn,$indice,xy,x) $x
             set tabTransition($tpn,$indice,xy,y) $y
          }
          e {
             if {[nextCar $ligne]=="p"} {
               set label [nextExpression $ligne " "]
               set indiceP [supNextExpression $label "p"]
               set ligne [supNextExpression $ligne "t"]          
               set indiceT [nextExpression $ligne " "]
               set ligne [supNextExpression $ligne " "]
               set ligne [supNextExpression $ligne " "]  
               set ligne [supNextExpression $ligne " "]  
               set weight [nextExpression $ligne " "]
               arcPlaceTransition $indiceP $indiceT 0 0 $weight PlaceTransition $couleur
            } else {
               set label [nextExpression $ligne " "]
               set indiceT [supNextExpression $label "t"]
               set ligne [supNextExpression $ligne "p"]          
               set indiceP [nextExpression $ligne " "]
               set ligne [supNextExpression $ligne " "]
               set ligne [supNextExpression $ligne " "]  
               set ligne [supNextExpression $ligne " "]  
               set weight [nextExpression $ligne " "]
               arcTransitionPlace $indiceP $indiceT 0 0 $weight $couleur
            }
          }  
          default {
         }
       }
    }
    close $file 
   redessinerRdP $c
   affiche [mc "done"]

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
  if {[string first [nextCar $chaine] "0123456789"]<0} {set resul 0}
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


proc romeo2tina {fichier} {
global tabPlace tabTransition tpn
global nbProcesseur scheduling
global fin ok
global modif
global infini


 if [string compare $fichier ""] {
   affiche "\n"
#   affiche [format [mc "-exporting PN to TINA file: %s ..."] $fichier]
   affiche [mc "-Exporting PN to TINA file: "]
   afficheBleu $fichier
   affiche " ..."
   set File [open $fichier w]
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
     if {$tabPlace($tpn,$i,statut)==$ok} {
        puts $File "p $tabPlace($tpn,$i,xy,x) $tabPlace($tpn,$i,xy,y) p$i $tabPlace($tpn,$i,jeton) n"
     }
    } 
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
     if {$tabTransition($tpn,$i,statut)==$ok} {
        if {$tabTransition($tpn,$i,dmax)==$infini} {
          set lft "w"
        } else {
          set lft $tabTransition($tpn,$i,dmax)
        }
        puts $File "t $tabTransition($tpn,$i,xy,x) $tabTransition($tpn,$i,xy,y) t$i $tabTransition($tpn,$i,dmin) $lft e"
     }
    }
   for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
     if {$tabTransition($tpn,$i,statut)==$ok} {
        for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} {
          puts $File "e p$tabTransition($tpn,$i,Porg,$j) 0 0 t$i 0 0 $tabTransition($tpn,$i,PorgWeight,$j) n"
       }
        for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} {
          puts $File "e t$i 0 0 p$tabTransition($tpn,$i,Pdes,$j) 0 0 $tabTransition($tpn,$i,PdesWeight,$j) n"
        }
      }
   }
#   puts $File "h $fichier"
 
   close $File
   affiche [mc "done"]
  } else {
    affiche "\n"
    affiche [mc "-Export to TINA aborted"]
  }
}

proc ecrireChoix {fenetre} {
global modeRedu

 if {$modeRedu==1} {
   $fenetre config -text [mc "       x size of GasTeX figure: "]
 } else {
   $fenetre config -text [mc "       reduction value (scale): "]
 }
}

proc export2gastex {c} {

global nomRdP
global modif
global cheminFichiers
global francais
global nomGastex sizeGastex
global modeRedu

   set sizeGastex 190
   set last [string first ".xml" $nomRdP] 
    if {$last>=0} {
         set nomGastex [string range $nomRdP 0 [expr $last -1]]  
    } else {
         set nomGastex $nomRdP
    }
  set ext ".tex"
  set nomGastex $nomGastex$ext
    
  wm withdraw .
  set fp .fenetreGastex
  catch {destroy $fp }
  toplevel $fp
  wm title $fp [mc "Export to GasTeX..."]

  frame $fp.dialogue
  pack $fp.dialogue -side top -fill both -expand yes
  set f $fp.dialogue


  frame $f.fileTex -bd 2 -relief sunken -bg white
  pack $f.fileTex -side top -fill both
  label $f.fileTex.lab
  pack $f.fileTex.lab -side left
  $f.fileTex.lab config -text [mc "GasTeX file: "]
  label $f.fileTex.nom -bg white
  pack $f.fileTex.nom -side left -fill both
  $f.fileTex.nom config -text "$nomGastex"

  frame $f.load -bd 2
  pack $f.load -side top -fill both
  button $f.load.open -text [mc "  Change GasTeX file  "] \
       -command "loadGastex $f"
  pack $f.load.open  -side left -expand 1   
  set modeRedu 1
  frame $f.taille
  pack $f.taille  -side top -expand 1   
  frame $f.taille.choix 
  pack $f.taille.choix  -side left -expand 1   
  radiobutton $f.taille.choix.a -text [mc "X size of the figure"] -variable modeRedu \
           -relief flat  -value 1  -width 16 -anchor w -selectcolor red -command "ecrireChoix $f.taille.size.label"
  radiobutton $f.taille.choix.b -text [mc "Reduction value"] -variable modeRedu \
           -relief flat  -value 2  -width 16 -anchor w -selectcolor red -command "ecrireChoix $f.taille.size.label"
  pack $f.taille.choix.a -side top -pady 2 -anchor w -fill x
  pack $f.taille.choix.b -side top -pady 2 -anchor w -fill x
  
  frame $f.taille.size -bd 2
  entry $f.taille.size.saisie -justify left -textvariable sizeGastex -relief sunken -width 10
  label $f.taille.size.label
  pack $f.taille.size.label -side left
  pack $f.taille.size.saisie -side left
  pack $f.taille.size -side right
  
  ecrireChoix $f.taille.size.label
 
  frame $fp.buttons
  pack $fp.buttons -side bottom -fill x -pady 2m
  button $fp.buttons.annuler -text [mc "Cancel"] -command  "destroy $fp"
  button $fp.buttons.accepter -default active -text [mc "Ok"]  \
      -command "validerGastex $fp"
  pack $fp.buttons.accepter $fp.buttons.annuler -side left -expand 1

  bind $fp <Return> "validerGastex $fp"
  bind $fp <<Echap>> "destroy $fp"

 proc validerGastex {fp} {
 global nomGastex sizeGastex
 global modeRedu
   set x 200
   set x [format %f $sizeGastex]
# pour ne garder que les chiffres importants :
   set x [expr $x/1]
   destroy $fp
   if [string compare $nomGastex ""] {
        romeo2gastex $nomGastex $x $modeRedu
   }
 }
}

proc loadGastex {fp} {
 global nomGastex

  set types {
   {"GasTeX file"     {.tex}      TEXT}
       }
#  set file [tk_getOpenFile -initialfile $fichierBib -filetypes $types ]
set file [tk_getSaveFile -initialdir [repertoire $nomGastex] -initialfile [nomSeul $nomGastex] -filetypes $types -title [mc "Change GasTeX file name"]]
 if {[string compare $file ""]} {
   $fp.fileTex.nom config -text "$file"
   set nomGastex $file
 }
}



proc romeo2gastex {fichier Xsize mode} {
global tabPlace tabTransition tpn 
global nbProcesseur scheduling
global fin ok
global modif
global infini
global scheduling

  set largeur [expr [tailleX]+50]
  set hauteur [expr [tailleY]+50]

  if {$mode==1} {
    if {$largeur>(2*$Xsize)} {
      set redu [expr $largeur/$Xsize]
    } else { 
      set redu 2
    }
  } else { 
    set redu $Xsize
    if {$redu < 1} {set redu 1}
  }
  set hauteur [format %2.1f [expr $hauteur/$redu]]
  set largeur [format %1.1f [expr $largeur/$redu]]
  set tailleP [format %1.1f [expr 20/$redu]]
  set tailleT [format %1.1f [expr 18/$redu]]
    
 if [string compare $fichier ""] {
   affiche "\n"
#   affiche [format [mc "-Exporting net to  file: %s ..."] $fichier]
   affiche [mc "-Exporting net to GasTeX file: "]
   afficheBleu "$fichier"
   affiche " ..."

   set File [open $fichier w]

    puts $File "% generated by romeo (IRCCyN) : a Tool for Time Petri Nets Analysis"

    puts $File "% \\usepackage\{gastex\}"

    if {$redu<=2} {
          puts $File "\\begin\{figure\} \n \{\\large \n \\begin\{center\}"
    } elseif {$redu < 3} {
          puts $File "\\begin\{figure\} \n \{\\normalsize \n \\begin\{center\}"
    } elseif {$redu < 4} {
          puts $File "\\begin\{figure\} \n \{\\footnotesize \n \\begin\{center\}"
    } elseif {$redu < 5} {
          puts $File "\\begin\{figure\} \n \{\\scriptsize \n \\begin\{center\}"
    } else {
          puts $File "\\begin\{figure\} \n \{\\tiny \n \\begin\{center\}"
    }   
    puts $File "\\begin\{picture\}($largeur,$hauteur)(30,-$hauteur)"

    puts $File "\% Places \n \\gasset\{Nw=$tailleP,Nh=$tailleP,Nmr=4,fillgray=1\} \n"
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
     if {$tabPlace($tpn,$i,statut)==$ok} {
       puts $File "\\gasset\{ExtNL=y,NLdist=[format %1.1f [expr 2/$redu]],NLangle=[nwse $tabPlace($tpn,$i,label,dx) $tabPlace($tpn,$i,label,dy)]\}"
       if {($scheduling==1)&&($tabPlace($tpn,$i,processeur)>0)} {
          set lelabel "\\begin\{tabular\}\{l\}\$$tabPlace($tpn,$i,label,nom)\$\\\\\$\\gamma=$tabPlace($tpn,$i,processeur), \\omega=$tabPlace($tpn,$i,priorite)\$\\end\{tabular\}"
       } else {
          set lelabel  "\$$tabPlace($tpn,$i,label,nom)\$"
       }
       puts $File "\\node(P$i)([format %1.1f [expr $tabPlace($tpn,$i,xy,x)/$redu]], -[format %1.1f [expr $tabPlace($tpn,$i,xy,y)/$redu]]) \{$lelabel\}"
      }
    } 
  
    puts $File "\% Transitions \n \\gasset\{Nw=$tailleT,Nh=[expr $tailleT/5],Nmr=0,fillgray=0\} \n" 
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
     if {$tabTransition($tpn,$i,statut)==$ok} {
     
        if {$tabTransition($tpn,$i,dmax)==$infini} {
          set lft "\\infty\["
        } else {
          set lft "$tabTransition($tpn,$i,dmax)\]"
        }
        puts $File "\\gasset\{ExtNL=y,NLdist=[format %1.1f [expr 4/$redu]],NLangle=[nwse $tabTransition($tpn,$i,label,dx) $tabTransition($tpn,$i,label,dy)]\}"
        
        if {$tabTransition($tpn,$i,dmin)+$tabTransition($tpn,$i,dmax)>0} {
          set leLabel "\\begin\{tabular\}\{l\}\$$tabTransition($tpn,$i,label,nom)\$\\\\\$\[$tabTransition($tpn,$i,dmin),$lft\$\\end\{tabular\}"
        } else { 
          set leLabel "\$$tabTransition($tpn,$i,label,nom)\$"
        }
        puts $File "\\node(T$i)([format %1.1f [expr $tabTransition($tpn,$i,xy,x)/$redu]],-[format %1.1f [expr $tabTransition($tpn,$i,xy,y)/$redu]]) \{$leLabel\}"
     }
    }

   for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} {
     if {$tabTransition($tpn,$i,statut)==$ok} {
        for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} {
          if {$tabTransition($tpn,$i,PorgWeight,$j)>1} {set weight $tabTransition($tpn,$i,PorgWeight,$j)} else {set weight ""}
          if {$tabTransition($tpn,$i,PorgType,$j)==1} {set weight "\\phi"}
          if {$tabTransition($tpn,$i,PorgNailx,$j)+$tabTransition($tpn,$i,PorgNaily,$j)>0} {
             puts $File "\\drawqbedge(P$tabTransition($tpn,$i,Porg,$j),[expr $tabTransition($tpn,$i,PorgNailx,$j)/$redu],-[expr $tabTransition($tpn,$i,PorgNaily,$j)/$redu],T$i)\{$weight\}"
          } else {
             puts $File "\\drawedge(P$tabTransition($tpn,$i,Porg,$j),T$i)\{$weight\}"
          } 
        }
        for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} {
         if {$tabTransition($tpn,$i,PdesWeight,$j)>1} {set weight $tabTransition($tpn,$i,PdesWeight,$j)} else {set weight ""}

         if {$tabTransition($tpn,$i,PdesNailx,$j)+$tabTransition($tpn,$i,PdesNaily,$j)>0} {
           puts $File "\\drawqbedge(T$i,[format %1.1f [expr $tabTransition($tpn,$i,PdesNailx,$j)/$redu]],-[format %1.1f [expr $tabTransition($tpn,$i,PdesNaily,$j)/$redu]],P$tabTransition($tpn,$i,Pdes,$j))\{$weight\}"
         } else {   
           puts $File "\\drawedge(T$i,P$tabTransition($tpn,$i,Pdes,$j))\{$weight\}"
         }
        }
      }
   }
   
   
   puts $File "% Marquage \n \\gasset\{ExtNL=n,NLdist=0,NLangle=0\}"
   
   for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} {
     if {$tabPlace($tpn,$i,statut)==$ok} {
        if {$tabPlace($tpn,$i,jeton)>0} {
          puts $File "\\nodelabel(P$i)\{\$\\bullet\$\}"
        }
     }   
    } 
    
   puts $File "\\end\{picture\} \n \\end{center} \n \} \n \\caption{$fichier} \n \\label{fig-$fichier} \n \\end\{figure\}"

 
   close $File
   affiche [mc "done"]
  } else {
    affiche "\n"
    affiche [mc "-Export to GasTeX aborted"]
  }
}

proc nwse {x y} {
     if {($x>10) && ($y>10)} {
         return "-45"
      } elseif {($x>10) && ($y<-10)} {
         return "+45"
      } elseif {$x>10} {
         return "0"
      } elseif {($x< -10) && ($y>10)} {
         return "225"
      } elseif {($x<-10) && ($y<-10)} {
         return "135"
      } elseif {($x<-10)} {
         return "180"
      } elseif {($y>10)} {
         return "-90"
      } else {
         return "90"
      }
}

proc export2MarkG {c untimed} {

    global nomRdP
    global cheminTemp plateforme
    global scheduling
    global gpnU gpnK
    global romeoPath

    # option est egale ˆ "a" automaton ou "g" graph
    # UKH est egal ˆ u pour UPPAAL,  k pour KRONOS ou h pour Hytech
    set executable $romeoPath
    append executable "bin/gpn2"

    if {[string compare $plateforme "windows"]} {
	set fileExec $executable
    } else {
	set ext .exe
	set fileExec $executable$ext
    }
    
    if {[file exists $fileExec]} {   
     affiche "\n export $nomRdP to MarkG input format ..."
     if {$untimed ==1} {
 	    set lepid [exec $executable -mg $nomRdP > $cheminTemp/gpn.log &]
	 } else {
	   if {$scheduling==0} {
	    set lepid [exec $executable -mg -d $nomRdP > $cheminTemp/gpn.log &]
	   } else {
	    set lepid [exec $executable -mg -d -s $nomRdP > $cheminTemp/gpn.log &]
	   }
	 }  
	 set npid [lindex $lepid 0]
	 	afficheGpnLog $npid "$cheminTemp/gpn.log"
        affiche "pid = $npid ... done"
	 update
           
    } else { 
	affiche "\n"
	affiche [format [mc "-Unable to run %s - program not found!"] $executable]
    }

}

