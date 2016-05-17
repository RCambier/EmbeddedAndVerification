package require Img
package require xml
package require BWidget
# import les fonctions i18n
namespace import ::msgcat::*


global cheminFichiers
global modif
global nomRdP
global tabPlace
global tabTransition
global tabConstraint
global nbConstraints
global tpn
global listeOnglets
global project

global tabFlechePT
global tabFlecheTP
global tabNoeud
global tabColor defaultTabColor couleurCourante
global newFPT
global newFTP
global nbProcesseur
global deltaX
global deltaY
global maxX
global maxY
global zoom
global computOption
global synchronized
#global constraints

global versionRomeo
global dos plateforme 
global editAuto
global francais
global gpnU gpnK tpn2taU tpn2taK

# Initialisation des variables booleennes globales
global fin
global ok
global destroy
global detruirePlace
global detruireTransition
global detruireFleche
global creerLien
global creerPlace
global creerTransition
global creerNoeud
global detruireNoeud
global allowedArc scheduling typePN parameters
global infini
global parser
global select
global quadrillage
global optionTrace optionSize
global simulatorOn
global simulator
global cheminPref cheminTemp
global dimension
global firstTime
global property

set property ""

set firstTime(menu) 1
set firstTime(control) 1

# path to romeo (for binary releases)
# for sources, windows-binary and MacOSX-binary releases
global romeoPath
set romeoPath "./"
# uncomment the following lines to build linux binary release
###LINUX set romeoPath [file dirname [info script]]
###LINUX set romeoPath [string map {"romeo/lib/app-romeo" ""} $romeoPath]

# initialisation des variables globales




set dimension(place) 8
set dimension(hauteurTransition) 4
set dimension(largeurTransition) 12
set dimension(jeton) 2
set dimension(noeud) 2
set dimension(flush) 4

set parameters 0
set scheduling 0
# 1 pour ttpn, 2 pour ptpn
set typePN 1 

set allowedArc(reset) 1
set allowedArc(read) 1
set allowedArc(logicInhibitor) 1
set allowedArc(timedInhibitor) 0
set computOption(node) -1
set computOption(token) 50000
set computOption(event) -1
set computOption(depth) -1
set computOption(hull) 2
set couleurCourante(Arc) 0
set couleurCourante(Place) 0
set couleurCourante(Transition) 0

 set defaultTabColor(Arc,0) black
 set defaultTabColor(Arc,1) gray
 set defaultTabColor(Arc,2) blue
 set defaultTabColor(Arc,3) #beb760
 set defaultTabColor(Arc,4) #be5c7e
 set defaultTabColor(Arc,5) #46be90
 set defaultTabColor(Place,0) SkyBlue2
 set defaultTabColor(Place,1) gray
 set defaultTabColor(Place,2) cyan
 set defaultTabColor(Place,3) green
 set defaultTabColor(Place,4) yellow
 set defaultTabColor(Place,5) brown
 set defaultTabColor(Transition,0) yellow
 set defaultTabColor(Transition,1) gray
 set defaultTabColor(Transition,2) cyan
 set defaultTabColor(Transition,3) green
 set defaultTabColor(Transition,4) SkyBlue2
 set defaultTabColor(Transition,5) brown

for {set i 0} {$i <= 5}   {incr i} {
  set tabColor(Place,$i) $defaultTabColor(Place,$i)
  set tabColor(Transition,$i) $defaultTabColor(Transition,$i)
  set tabColor(Arc,$i) $defaultTabColor(Arc,$i)
}

set select(etat) 0
set select(x1) 1
set select(x2) 1
set select(y1) 1
set select(y2) 1
set select(vide) 1
set select(red) 0
set select(listePlace) [list]
set select(listeLabelPlace) [list]
set select(listeTransition) [list]
set select(listeLabelTransition) [list]
set select(listeNoeud) [list]
set simulatorOn 0
set simulator(ok) 0
set synchronized [list]

set listeOnglets(tpn) [list]
set listeOnglets(indice) [list]

set tabNoeud(1,arc) 0

set infini 10000000
set francais 0
set dos 1
set editAuto 1
set deltaX 0
set deltaY 0
set creerLien 0
set creerPlace 0
set creerTransition 0
set creerNoeud 0
set detruireNoeud 0
set ok 11
set fin 12
set destroy 13
set detruirePlace 0
set detruireTransition 0
set detruireFleche 0
set modif(0) 0

# definition de la taille par defaut de la fenetre de saisie du TPN
# (dedonner dans map)
set maxX 1600
set maxY 1130

set quadrillage 1
set zoom 1

#option du check :
set optionTrace 1
set optionSize 0

font create font1 -family Times -size 12
font create fontPetit -family Times -size 12
font create fontMenu -family Helvetica -size 10

tk_setPalette background lightgray disabledBackground gray

# specific to MacOSX
if {$tcl_platform(os) == "Darwin"} {
    set tk::mac::useCGDrawing 1
    #    set tk::mac::CGAntialiasLimit 1
}

#**********************************************************************
set versionRomeo "Romeo v2.10.1"

set plateforme $tcl_platform(platform)
if {[string compare $plateforme "windows"]} {
    set plateforme $tcl_platform(os)
}
puts "$versionRomeo on $plateforme platform"

# changer de repertoire courant
puts [file dirname [info script]]
cd [file dirname [info script]]


# cd scripts
# puts [pwd]
source ./scripts/map.tcl
source ./scripts/manifich.tcl
source ./scripts/manitag.tcl
source ./scripts/dessinRdP.tcl
source ./scripts/maniauto.tcl
source ./scripts/xmltpn.tcl
source ./scripts/place.tcl
source ./scripts/parameters.tcl
source ./scripts/controlPanel.tcl
source ./scripts/manitpn.tcl
source ./scripts/veriftpn.tcl
source ./scripts/tina2romeo.tcl
source ./scripts/user_pref.tcl
source ./scripts/synchro.tcl
source ./scripts/onglet.tcl
source ./scripts/unfold.tcl
source ./scripts/stateSpace.tcl
#source ./scripts/manage.tcl

#chemin

set cheminPref [preferences_dir]

if {[file exists [preferences_filename]]} {
    # load pref
    load_preferences
} elseif {![file exists [preferences_dir]]} {
    file mkdir [preferences_dir]
    save_default_preferences
} else {
    save_default_preferences
}
load_preferences
if {![file exists [temp_dir]]} {
    file mkdir [temp_dir]
}
set cheminTemp [temp_dir]
#}

# update_locale
proc update_locale {} {
    global francais
    if {$francais == 1} {
	mclocale fr

    } else {
	mclocale en
    }	
}

#Selection de la locale
update_locale 
#chargement des fichiers (dans msgs)
mcload [file join [file dirname [info script]] msgs]


#*******************************************************************
# initialisation***********
set project(nbTPN) 0
set tpn 0
set nbProcesseur($tpn) 0
set nomRdP($tpn) "noName.xml"

# Statut des places : ok, detroy, ou fin
set tabPlace($tpn,1,statut) $fin
set tabTransition($tpn,1,statut) $fin

set tabConstraint($tpn,0) ""
set nbConstraints($tpn) 1


set newFTP(transition) 0
set newFPT(place) 0

if {$typePN==-2} { set parameters 0}

#********************************************************************
#init du parser xml

if {[catch {package require expat 1.0}]} {
    if {[catch {package require xml}]} {
	#           error "unable to load a XMLparser"
	set button [tk_messageBox -icon error -message [mc "Unable to load a XMLparser \n\n\ Install    \"expat\" \n          or   \"tcltk 8.4.7 (Activetcl or tclAqua) \""]]
    } else { set parser [::xml::parser] }
} else {
    set parser [expat xmlparser]
}

#package require xml
#set parser [xml::parser myparser]

$parser configure -elementstartcommand elementDebut \
    -characterdatacommand procData -elementendcommand elementFin

# *************************************************************

procedurePlace
source ./scripts/simulator.tcl


proc perso {} {
    source ./scripts/manitag.tcl
    source ./scripts/manitpn.tcl

}

#********************************************************************
proc irccyn {} {
    global francais
    global versionRomeo

    set logo .image1
    catch {destroy $logo}
    toplevel $logo
    wm title $logo "IRCCyN"
    wm iconname $logo "Image1"
    # positionWindow $logo

    frame $logo.image
    # catch {image delete image1a}
    image create photo image1a -file "img/logolabo.png"
    label $logo.image.l1 -image image1a -bd 1 -relief sunken

    # catch {image delete image1b}
    image create photo image1b -file "img/romeo.png"
    label $logo.image.l2 -image image1b -bd 1 -relief sunken

    pack $logo.image.l1  -side left
    pack $logo.image.l2  -side right
    pack $logo.image  -side top

    set copyright "Copyright IRCCyN (c) All rights reserved\n"


    text $logo.text -width 80 -height 30 -bg white
    pack $logo.text -side top -expand yes
    $logo.text tag configure rouge -foreground darkred
    $logo.text tag configure bleu -foreground blue
    $logo.text tag configure bleuF -foreground darkblue
    $logo.text tag configure surgris -background #a0b7ce
    $logo.text tag configure souligne -underline on

    $logo.text insert end "\n\n"
    $logo.text insert end "ROMEO :" surgris       
    $logo.text insert end "    $versionRomeo \n" rouge 
    $logo.text insert end "           $copyright\n" 
    $logo.text insert end "URL:" souligne
    $logo.text insert end "    http:\/\/romeo.rts-software.org\/ \n" bleuF
    $logo.text insert end "e-mail:" souligne
    $logo.text insert end " romeo@irccyn.ec-nantes.fr\n\n" bleuF
    $logo.text insert end "Romeo team:" souligne
    $logo.text insert end "\n            Olivier H. ROUX , \n            Didier LIME , \n            Louis-Marie TRAONOUEZ , \n            Charlotte SEIDNER \n\n" bleuF
    
    $logo.text insert end "IRCCyN :" surgris
    $logo.text insert end " Institut de Recherche en Communication et Cybernetique de Nantes\n" rouge
    $logo.text insert end "         Equipe Systemes Temps-Reel\n\n" rouge
    $logo.text insert end " UMR CNRS 6597\n Ecole Centrale de Nantes
 Ecole des Mines de Nantes
 Universite de Nantes\n\n" bleu
    $logo.text insert end "URL:" souligne
    $logo.text insert end " http:\/\/www.irccyn.ec-nantes.fr\n\n" bleuF
    $logo.text insert end "Address:" souligne
    $logo.text insert end " IRCCyN / ECN
 1 rue de la Noe BP92101
 44321 NANTES Cedex 3 \n" bleuF
}
