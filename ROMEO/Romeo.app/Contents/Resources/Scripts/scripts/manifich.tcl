 # procedure aide
# procedure imprime
# procedure quitter
# procedure aiguillageEnregistrer, enregistrerSous, enregistrerTpnXml
# procedure compilerRDP, verifSem,
# procedures diverses : tailleX, tailleY, sansEspace, slach, parcourir, repertoire, nomSeul

# les procedures associées au lancement du calcul du GDC comme fautIlSauver, calculGDC, calculQuiGDC sont dans stateSpace.tcl

#*******************************HELP*********************************** 


proc aide {} { 
    global francais 
    global versionRomeo 
 


    set help .fenetreAide 
    catch {destroy $help} 
    toplevel $help 
     
    wm title $help [mc "Romeo Help"] 
     
    text $help.text -yscrollcommand "$help.scroll set" -setgrid true \
	-width 130 -height 50 -wrap word -bg white 
    scrollbar $help.scroll -command "$help.text yview" 
     
    pack $help.scroll -side right -fill y 
     
    pack $help.text -expand yes -fill both 
    $help.text tag configure rouge -foreground red 
    $help.text tag configure bleu -foreground blue 
    $help.text tag configure surgris -background #a0b7ce 
    $help.text tag configure souligne -underline on 
 
    if {$francais==1} { 
	$help.text insert end "$versionRomeo \n Ce logiciel est en cours de 
réalisation et ses résultats peuvent comporter des erreurs.\n 
Cette version permet : \n\n" 
	$help.text insert end "Sur les Réseaux de Petri T-Temporels (TPN) :" souligne   
	$help.text insert end " (et en utilisant la librairie DBM d'Uppaal) \n 
  - le calcul du graphe des classes d'états  \n 
  - le calcul de l'automate (temporisé) des classes d'états : calcul du graphe 
    des classes d'état du RdPT sous la forme d'un automate temporisé (aux 
formats UPPAAL ou KRONOS). Cet automate temporisé est temporellement bisimilaire au TPN. \n 
  - le calcul du graphe des zones préservant soit les marquages, soit les propriété temporelles LTL \n
  - le calcul de l'automate (temporisé) des marquages : calcul du graphe des régions du RdPT sous la forme d'un automate temporisé. Cet automate  temporisé est temporellement bisimilaire au TPN. \n 
  - une traduction structurelle des RdPs temporels en automates temporisés (format UPPAAL). Cet automate  temporisé est temporellement bisimilaire au TPN. \n 
  - la vérification à la volée de propriétés TCTL \n  
  - la simulation du réseau\n\n" 
	$help.text insert end "Sur les réseaux de Petri à chronomètres " souligne 
	$help.text insert end "(soit une extension à l'ordonnancement des Réseaux de Petri temporels (scheduling-TPN), soit des réseaux de Petri temporels avec arcs inhibiteurs temporels) : \n 
   - une surapproximation (avec des DBM) du calcul du graphe des classes étendues  \n 
   - le calcul exact (à l'aide de Parma Polyhedra Library, une bibliothèque de manipulation de polyèdres) du graphe des classes des réseaux à chronomètres \n
   - le calcul exact du graphe des classes des réseaux à chronomètres en utilisant à la fois des DBM et des polyèdres \n 
   - le calcul de l'automate à stopwatch des classes étendues (format Hytech). Cet automate à stopwatch est temporellement bisimilaire au réseau de Petri à chronomètres initial. \n 
  - la vérification à la volée de propriétés TCTL \n  
  - la simulation du réseau\n\n" 
	$help.text insert end "Sur les réseaux de Petri paramétrés " souligne 
	$help.text insert end ": \n 
  - le calcul exact (à l'aide de Parma Polyhedra Library) du graphe des classes paramétré \n
  - la vérification à la volée de propriétés TCTL paramétrées \n  
  - la simulation du réseau\n\n" 
	 
	$help.text insert end " 
                                                     AIDE                                                      " souligne 
	$help.text insert end "\n \n" 
	$help.text insert end "A. Saisir un réseau de Petri :" souligne 
	$help.text insert end "\n \n A.1) Dans le "
	$help.text insert end "Panneau de contrôle" surgris 
	$help.text insert end "\n 
   -Sélectionner le type de réseau de Petri : temporels, à chronomètres (scheduling ou à arcs inhibiteurs temporels)
   -Sélectionner les formats de sortie 
   -Valider les types d'arcs autorisés (read, reset et inhibiteur logique)"
	$help.text insert end "\n \n A.2) Création des places/arcs/transitions dans le menu " 
	$help.text insert end "Editer" surgris 
	$help.text insert end " (ou " 
	$help.text insert end "click droit" rouge 
	$help.text insert end ") \n \n A.3)  Retourner en mode " 
	$help.text insert end "sélection" surgris 
	$help.text insert end " avec la bascule (en bas au centre) ou avec la touche " 
	$help.text insert end "Echap" rouge 
	$help.text insert end " \n \n" 
	$help.text insert end " A.4)  Saisir les caractéristiques des places, arcs et transitions par " 
	$help.text insert end "click droit (ou double-click)" rouge 
	$help.text insert end " sur l'élément \n \n A.5) " 
	$help.text insert end "Enregistrer" surgris 
	$help.text insert end " le PN " 
	$help.text insert end "          -> fichier.xml  \n \n \n" bleu 
	$help.text insert end "B. Calcul sur le réseau de Petri autonome sous-jacent :" souligne 
	$help.text insert end "\n \n B.1)  Saisir le PN (temporel ou non) \n \n B.2) Dans le menu " 
	$help.text insert end "PN" surgris 
	$help.text insert end " : Calcul du " 
	$help.text insert end  "graphe des marquages" surgris 
	$help.text insert end "-> fichier-untimed.txt \n \n" bleu 
	$help.text insert end "C. Calcul sur les réseaux de Petri temporels (TPN) :" souligne 
	$help.text insert end "\n \n C.1) Traduire (traduction structurelle) le TPN en Automate temporisé :"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Traduction structurelle en Automate Temporisé " 
	$help.text insert end "    -> choisir-nom-fichier.xta \n \n \n" bleu 
	$help.text insert end " C.2) Calculer le graphe des classes d'état d'un TPN :"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Calcul du "  
	$help.text insert end "graphe des classes " surgris 
	$help.text insert end " -> fichier-scg.txt \n \n" bleu 
	$help.text insert end " C.3) Calculer le graphe des zones d'un TPN :"  
	$help.text insert end "\n \n     Menu : " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Graphe des zones "  
	$help.text insert end "préservant les marquages (inclusion)  "  
	$help.text insert end " :\n \n"  
	$help.text insert end "        -> fichier-ma.   \n \n" bleu 
	$help.text insert end "      Menu : " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Graphe des zones préservant LTL  "  
	$help.text insert end " :\n \n"  
	$help.text insert end "        -> fichier-zbg. \n \n" bleu 
	$help.text insert end " C.4) Calculer l'automate (temporisé) des classes d'état d'un TPN :"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Calcul de l'"  
	$help.text insert end "automate temporisé des classes " surgris 
	$help.text insert end "  -> fichier-scta.xta " bleu 
	$help.text insert end "\n \n     Remarque : le critère de convergence avec renommage conduit a un automate plus petit que sans renommage \n \n \n" 
	$help.text insert end " C.5) Calculer l'automate (temporisé) des marquages d'un TPN :"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Calcul de l'"  
	$help.text insert end "automate temporisé des marquages " surgris 
	$help.text insert end "\n " 
	$help.text insert end "  -> fichier-ma.xta " bleu 
	$help.text insert end "\n \n \n" 
	$help.text insert end " C.6) Vérification à la volée d'une propriété TCTL sur un TPN :"  
	$help.text insert end "\n \n     - Bouton " 
	$help.text insert end "Vérifier" surgris 
	$help.text insert end " : Saisir la propriété et l'enregistrer ou charger le fichier de la propriété \n\n     - clicker sur "  
	$help.text insert end "Vérifier la propriété" surgris 
	$help.text insert end "\n \n" 
	$help.text insert end " C.7) Simulation du TPN :"  
	$help.text insert end "\n \n     - Bouton " 
	$help.text insert end "Simuler" surgris 
	$help.text insert end " : Les places marquées, les transitions sensibilisées et les transitions tirables apparaissent en couleur. Les contraintes (zones) temporelles sont affichées dans une fenêtre séparée. \n\n     - clicker sur la transition que vous voulez tirer\n \n"  
	$help.text insert end "D. Sur les réseaux de Petri à chronomètres (scheduling-TPN ou TPN à arcs inhibiteurs temporels) :" souligne 
	$help.text insert end "\n \n  D.1) Dans le  " 
	$help.text insert end "Panneau de contrôle" surgris 
	$help.text insert end " : sélectionner " 
	$help.text insert end "Scheduling-TPN" surgris 
	$help.text insert end " ou " 
	$help.text insert end "Stopwatch-PN" surgris 
	$help.text insert end "\n \n  D.2) Si scheduling-TPN alors \n     -"
	$help.text insert end "Définir l'ordonnanceur" surgris 
	$help.text insert end "\n     -Saisir le scheduling-TPN  \n " 
	$help.text insert end "    -Saisir les paramètres " 
	$help.text insert end "processeur" surgris 
	$help.text insert end " et  " 
	$help.text insert end "priorité" surgris 
	$help.text insert end " de chaque place \n \n D.3) Calcul de l'espace d'état" 
	$help.text insert end "\n \n     Dans le menu " 
	$help.text insert end "réseau à chronomètres" surgris 
	$help.text insert end " :\n \n      " 
	$help.text insert end "      * Surapproximation du graphe des classes étendues"  
	$help.text insert end " (Sélection du format dans le \"panneau de contrôle\")  :\n \n" 
	$help.text insert end " -> fichier-scg. (txt ou aut ou mec) \n \n" bleu 
	$help.text insert end "      * Calcul exact (polèdres) du graphe des classes étendues"  
	$help.text insert end "   :\n \n" 
	$help.text insert end " -> fichier-scg.  \n \n" bleu
	$help.text insert end "      * Calcul exact (DBM+polèdres) du graphe des classes étendues"  
	$help.text insert end "  :\n \n" 
	$help.text insert end " -> fichier-scg. \n \n" bleu 
	$help.text insert end "      * Automate à stopwatch des classes étendues" 
	$help.text insert end "  -> fichier-scswa.hy \n \n \n" bleu 
	$help.text insert end " D.4) Vérification à la volée d'une propriété TCTL :"  
	$help.text insert end "\n \n     - Bouton " 
	$help.text insert end "Vérifier" surgris 
	$help.text insert end " : Saisir la propriété et l'enregistrer ou charger le fichier de la propriété \n\n     - clicker sur "  
	$help.text insert end "Vérifier la propriété" surgris 
	$help.text insert end "\n \n" 
	$help.text insert end " D.5) Simulation du stopwatch-PN :"  
	$help.text insert end "\n \n     - Bouton " 
	$help.text insert end "Simuler" surgris 
	$help.text insert end "\n      clicker sur la transition sensibilisée que vous voulez tirer\n \n"  
	$help.text insert end "E. Sur les réseaux de Petri paramétrés :  (TPN paramétrés ou stopwacth-PN paramétrés) :" souligne 
	$help.text insert end "\n \n E.1) Sélectionner Parametric-PN dans le " 
	$help.text insert end "Panneau de contrôle" surgris 
	$help.text insert end "\n \n E.2) Donner les contraintes paramétrées temporelles de chaque transition ( " 
	$help.text insert end " (click-droit ou double-click" rouge 
	$help.text insert end " sur les transitions) \n \n     Les contraintes temporelles paramétrées des transitions doivent être linéaire de la forme : "
	$help.text insert end "const := term op const " bleu
	$help.text insert end "\n     term := k*p | p*k | k, avec k un coefficient entier et p un paramètre, op est dans \{+,-\}"
	$help.text insert end "\n \n E.3) Donner les contraintes paramétriques globales du réseau dans le  menu " 
	$help.text insert end "réseau paramétré" surgris 
	$help.text insert end " -> Constraintes sur les paramètres \n\n"
	$help.text insert end "     Les contraintes paramétrées globales doivent être de la forme : "
	$help.text insert end "const1 op const2 " bleu
	$help.text insert end "\n     où const1 et const2 sont des contraintes temporelles paramétrées et op est dans \{>,>=,=,<,<=\}."
	$help.text insert end "\n \n E.4) Graphe des classes d'état paramétré :" 
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "réseau paramétré" surgris 
	$help.text insert end " ->    Graphe des Classes Paramétré \n \n E.5) Pour vérifier une propriété TCTL paramétrée :"  
	$help.text insert end "\n \n     Utiliser le bouton " 
	$help.text insert end "Vérifier" surgris 
	$help.text insert end "  pour éditer et vérifier la propriété\n\n"
	$help.text insert end "          * définir une"
	$help.text insert end " taille de trace maximum" surgris
	$help.text insert end "(par défaut à 0 si pas de taille maximale):\n"
	$help.text insert end "            arrête le calcul et renvoie une approximation du résultat (condition suffisante)"
	$help.text insert end "\n \n \n" 
	$help.text insert end " D.4) Simulation du réseau paramétré :"  
	$help.text insert end "\n \n     - Bouton " 
	$help.text insert end "Simuler" surgris 
	$help.text insert end "\n      clicker sur la transition sensibilisée que vous voulez tirer\n \n"  

    } else { 
	#******************** en anglais****************** 
	$help.text insert end "$versionRomeo \n\n This version performs : \n\n" 
	$help.text insert end "On T-Time Petri nets (TPN) " souligne   
	$help.text insert end " (and thanks the Uppaal DBM library) :\n
  - computation of the State Class Graph of Time Petri Nets  \n 
  - computation of the State Class (Timed) Automaton of Time Petri Nets (Uppaal or Kronos input formats). This timed automaton and the TPN are timed bisimilar.\n
  - computation of the Zone-Based Graph that preserve either markings or LTL temporal properties\n
  - computation of the Marking (Timed) Automaton of Time Petri Nets (Uppaal input formats). This timed automaton and the TPN are timed bisimilar.\n 
  - structural translation from Time Petri Nets to Timed Automata (Uppaal input format). This timed automaton and the TPN are timed bisimilar.\n 
  - on-the-fly verification of TCTL properties \n 
  - simulation \n\n" 
	$help.text insert end "On stopwatch Time Petri nets (scheduling-TPN or TPN with timed inhibitor arcs) :" souligne   
	$help.text insert end "\n 
  - overapproximation (with DBM) of the computation of the extended State Class Graph of TPN\n 
  - exact computation (thanks to Parma Polyhedra Library) of the extended State Class Graph of scheduling-TPN (TEXT, MEC or Aldebaran formats)\n 
  - exact computation with both DBM and polyhedra of the extended State Class Graph of scheduling-TPN \n 
  - computation of the State Class stopwatch automaton (Hytech input format). This stopwatch automaton and the scheduling-TPN are timed bisimilar \n
  - on-the-fly verification of TCTL properties \n 
  - simulation \n\n" 
	$help.text insert end "On parametric Petri nets (PTPN or scheduling-PTPN or PTPN with timed inhibitor arcs) :" souligne   
	$help.text insert end "\n 
  - exact computation (thanks to Parma Polyhedra Library) of the parametric State Class Graph\n 
  - on-the-fly verification of parametric TCTL properties \n
  - parametric simulation. \n\n" 
 
	$help.text insert end " 
                                               HELP                                                 " souligne 
	$help.text insert end "\n \n" 
	$help.text insert end "A. To create the net :" souligne 
	$help.text insert end "\n \n A.1) In the "
	$help.text insert end "control panel" surgris 
	$help.text insert end "\n     -Select TPN type (TPN or scheduling-TPN or stopwatch-TPN (i.e. TPN with timed inhibitor arcs) ) "
	$help.text insert end "\n     -Select  output formats in the " 
	$help.text insert end "\n     -Valid allowed logical arcs (read, reset and logical inhibitor arcs) " 
	$help.text insert end "\n \n A.2) Create places/arcs/transitions with " 
	$help.text insert end "Edit" surgris 
	$help.text insert end " menu (or " 
	$help.text insert end "right-click" rouge 
	$help.text insert end ") \n \n A.3) Go back to " 
	$help.text insert end "selection" surgris 
	$help.text insert end " mode with the button (or " 
	$help.text insert end "Escape" rouge 
	$help.text insert end ")\n \n" 
	$help.text insert end " A.4) Give places, arcs and transitions characteristics (with " 
	$help.text insert end "right-click or double-click" rouge 
	$help.text insert end ") \n \n A.5) " 
	$help.text insert end "Save" surgris 
	$help.text insert end " TPN " 
	$help.text insert end "          -> file.xml  \n \n \n" bleu 
	$help.text insert end "B. On the underlying Petri net  :" souligne 
	$help.text insert end "\n \n B.1)  Create PN (TPN or scheduling-TPN) \n \n B.2) menu : " 
	$help.text insert end "PN" surgris 
	$help.text insert end " Compute the marking graph (Select the format in the control panel) :\n \n" 
	$help.text insert end "        - text     "  
	$help.text insert end "-> file-untimed.txt \n \n" bleu 
	$help.text insert end "C. On time Petri nets (TPN) :" souligne 
	$help.text insert end "\n \n C.1) Translate (structural translation) Time Petri Net to Timed Automata :"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Structural translation to  Timed Automata (UPPAAL input format) " 
	$help.text insert end "    -> choose-file-name.xta \n \n \n" bleu 
	$help.text insert end " C.2) To compute the State Class Graph of a TPN (Select the format in the control panel) :"  
	$help.text insert end "\n \n     Menu : " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : state Class Graph "  
	$help.text insert end "with formats "  
	$help.text insert end " :\n \n"  
	$help.text insert end "        - text     "  
	$help.text insert end " -> file-scg.txt \n \n" bleu 
	$help.text insert end " C.3) To compute the Zone based Graph of a TPN (Select the format in the control panel) :"  
	$help.text insert end "\n \n     Menu : " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Zone Based Graph "  
	$help.text insert end "preserving marking (inclusion)  "  
	$help.text insert end " :\n \n"  
	$help.text insert end "        -> file-ma.   \n \n" bleu 
	$help.text insert end "\n    Menu : " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Zone Based Graph preserving LTL  "  
	$help.text insert end " :\n \n"  
	$help.text insert end "        -> file-zbg.   \n \n" bleu 
	$help.text insert end " C.4) To compute the State Class Timed Automaton of a TPN (Select the format in the control panel):"  
	$help.text insert end "\n \n     Menu :" 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : State Class Timed Automaton "  
	$help.text insert end " with formats :"  
	$help.text insert end "\n \n       - UPPAAL : no clock renaming " 
	$help.text insert end "  -> file-scta.xta " bleu 
	$help.text insert end "\n \n  \n" 
	$help.text insert end " C.5) To compute the Marking Timed Automaton of a TPN (Select the format in the control panel):"  
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "TPN" surgris 
	$help.text insert end " : Marking Timed Automaton "  
	$help.text insert end " with formats :"  
	$help.text insert end "\n \n       - UPPAAL " 
	$help.text insert end " \n \n \n" 
	$help.text insert end " C.6) To check TCTL property on the net (on the fly model checking) :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Check" surgris 
	$help.text insert end " button to edit and check the property "  
	$help.text insert end "\n \n \n" 
	$help.text insert end " C.7) TPN Simulation :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Simulate" surgris 
	$help.text insert end " button and click on the transition you want to fire "  
	$help.text insert end "\n \n \n" 
	$help.text insert end "D. On stopwatch TPN :  scheduling-TPN or TPN with timed inhibitor arcs :" souligne 
	$help.text insert end "\n \n D.1) In the " 
	$help.text insert end "Control panel" surgris 
	$help.text insert end " : select " 
	$help.text insert end "scheduling-TPN" surgris 
	$help.text insert end " or " 
	$help.text insert end "stopwatch-PN (timed inhibitor arcs)" surgris 
	$help.text insert end "\n \n D.2)  If scheduling-TPN then : \n         -" 
	$help.text insert end "Define scheduler" surgris 
	$help.text insert end ",\n         -create the scheduling-TPN, \n" 
	$help.text insert end "         -and give characteristics : " 
	$help.text insert end "processor" surgris 
	$help.text insert end " and " 
	$help.text insert end "priority" surgris 
	$help.text insert end " of places \n \n D.3) State space computation (Select the format in the control panel)" 
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "stopwatch-PN" surgris 
	$help.text insert end " :\n \n      * Overapproximation of the extended state class graph with formats :\n \n"
	$help.text insert end "      -> file-scg.  \n \n" bleu
	$help.text insert end "      * Exact computation (polyhedra) of the extended state class graph with formats :\n \n"  
	$help.text insert end " -> file-scg.  \n \n" bleu
	$help.text insert end "      * Exact computation (DBM+polyhedra) of the extended state class graph with formats :\n \n"
	$help.text insert end " -> file-scg.  \n \n" bleu
	$help.text insert end "        * Extended State class stopwatch automaton \n \n " 
	$help.text insert end "      -> file-scswa.hy \n \n \n" bleu
	$help.text insert end " D.4) To check TCTL property on the net (on the fly model checking) :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Check" surgris 
	$help.text insert end " button to edit and check the property "  
	$help.text insert end "\n \n \n" 
	$help.text insert end " D.5) stopwatch-PN simulation :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Simulate" surgris 
	$help.text insert end " button and click on the transition you want to fire "  
	$help.text insert end "\n \n \n" 
	$help.text insert end "E. On parametric PN :  parametric TPN or parametric stopwatch PN :" souligne 
	$help.text insert end "\n \n E.1) Select parametric-PN in the " 
	$help.text insert end "Control panel" surgris 
	$help.text insert end "\n \n E.2)  Give the parametric timed constraint of each transition  (with " 
	$help.text insert end "right-click or double-click" rouge 
	$help.text insert end " on transitions) \n \n     Parametric timed Constraint of transition must be of the form: "
	$help.text insert end "const := term op const " bleu
	$help.text insert end "\n     term := k*p | p*k | k, with k an integer coefficient and p a parameter, op is in \{+,-\}"
	$help.text insert end "\n \n E.3) Give the global parametric constraints of the net in menu " 
	$help.text insert end "Parametric-PN" surgris 
	$help.text insert end " -> Constraints on parameters \n\n"
	$help.text insert end "     Global parametric timed Constraint must be of the form: "
	$help.text insert end "const1 op const2 " bleu
	$help.text insert end "\n     where const1 and const2 are parametric timed Constraints and op is in \{>,>=,=,<,<=\}."
	$help.text insert end "\n \n E.4) Parametric State space Computation :" 
	$help.text insert end "\n \n     Menu " 
	$help.text insert end "stopwatch-PN" surgris 
	$help.text insert end " ->    parametric state class graph \n \n E.5) To check parametric TCTL property on the net :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Check" surgris 
	$help.text insert end " button to edit and check the property\n\n "
	$help.text insert end "          * define a"
	$help.text insert end " maximum trace size" surgris
	$help.text insert end "(by default 0 if none):\n"
	$help.text insert end "            stop the computation and return an approximated result (sufficient condition)"
	$help.text insert end "\n \n \n" 
	$help.text insert end " E.6) TPN Simulation :"  
	$help.text insert end "\n \n     Use the " 
	$help.text insert end "Simulate" surgris 
	$help.text insert end " button and click on the transition you want to fire "  
	$help.text insert end "\n \n \n" 
	 
	 
	 
    } 
} 
 
 
#*************************************IMPRIMER*********************************************** 
 
proc imprimer {w c} { 
    global nomRdP tpn
    global format 
    global rotation 
    global reduction 
    global francais 
    global zoom 
 
    set oui 1 
 
    if { ![string compare "$nomRdP($tpn)" "noName.xml"]}  { 
        set reponse [tk_messageBox -message [mc "Save net before PostScript export?"] -type yesnocancel -icon question] 
	switch -exact $reponse { 
	    cancel { set oui 0 } 
	    yes {  enregistrerSousRdP $w } 
	} 
    } 
 
    if {$oui==1} { 
	set last [string first ".xml" "$nomRdP($tpn)"] 
 
	if {$last>=0} {set nomPs [string range "$nomRdP($tpn)" 0 [expr $last -1]]} else { set nomPs $nomRdP($tpn)} 
 
	set format  1 
	set rotation 0 
	set reduction 0 
 
	queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0 
 
	set fi .fenetreImprimer 
	catch {destroy $fi} 
	toplevel $fi 
	wm title $fi [format [mc "Creating PostScript file %s.ps"] $nomRdP($tpn)] 
	bind $fi <Return> "validerParametreImpression $nomPs $fi $c" 
 
	frame $fi.buttons 
	pack $fi.buttons -side bottom -fill x -pady 2m 
	button $fi.buttons.annuler -text [mc "Cancel"] -command  "destroy $fi" 
	button $fi.buttons.accepter -text [mc "Ok"]  \
	    -command "validerParametresImpression {$nomPs} $fi $c" 
	pack $fi.buttons.accepter $fi.buttons.annuler  -side left -expand 1 
 
 
 
	frame $fi.parametres 
	pack $fi.parametres  -side left -expand yes -fill y  -pady .5c -padx .5c 
 
	label $fi.parametres.label -text [mc "Parameters: "] 
	pack $fi.parametres.label -side top 
 
	frame $fi.parametres.sep -relief ridge -bd 1 -height 2 
	pack $fi.parametres.sep -side top -fill x -expand no 
 
	# **************** bouton de format (A4 A5) et de rotation (portrait paysage)*********************** 
 
	radiobutton $fi.parametres.option1 -text "A4" -variable format \
	    -relief flat  -value 1  -width 20 -anchor w 
	radiobutton $fi.parametres.option2 -text "A5" -variable format \
	    -relief flat  -value 2  -width 20 -anchor w 
	radiobutton $fi.parametres.portrait -text [mc "Portrait"] -variable rotation\
	    -relief flat  -value 0  -width 20 -anchor w 
	radiobutton $fi.parametres.paysage -text [mc "Landscape"] -variable rotation\
	    -relief flat  -value 1  -width 20 -anchor w 
 
 
	pack $fi.parametres.option1  -side top -pady 2 -anchor w -fill x 
	pack $fi.parametres.option2  -side top -pady 2 -anchor w -fill x 
	pack $fi.parametres.portrait  -side top -pady 2 -anchor w -fill x 
	pack $fi.parametres.paysage  -side top -pady 2 -anchor w -fill x 
 
 
	# **************************** bouton de reduction ************************************** 
 
	frame $fi.reduction 
	pack $fi.reduction  -side left -expand yes -fill y  -pady .5c -padx .5c 
 
	label $fi.reduction.label -text [mc "Reduction: "] 
	pack $fi.reduction.label -side top 
 
	frame $fi.reduction.sep -relief ridge -bd 1 -height 2 
	pack $fi.reduction.sep -side top -fill x -expand no 
 
 
	radiobutton $fi.reduction.option0 -text [mc "Automatic"] -variable reduction \
	    -relief flat  -value 0  -width 20 -anchor w 
	radiobutton $fi.reduction.option200 -text "200 %" -variable reduction \
	    -relief flat  -value 0.5  -width 20 -anchor w 
 
	radiobutton $fi.reduction.option1 -text "100 %" -variable reduction \
	    -relief flat  -value 1  -width 20 -anchor w 
 
	radiobutton $fi.reduction.option2 -text "75 %" -variable reduction\
	    -relief flat  -value 1.5  -width 20 -anchor w 
 
	radiobutton $fi.reduction.option3 -text "50 %" -variable reduction\
	    -relief flat  -value 2  -width 20 -anchor w 
 
	radiobutton $fi.reduction.option4 -text "25 %" -variable reduction \
	    -relief flat  -value 4  -width 20 -anchor w 
	radiobutton $fi.reduction.option5 -text "10 %" -variable reduction \
	    -relief flat  -value 10  -width 20 -anchor w 
 
	pack $fi.reduction.option0  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option200  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option1  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option2  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option3  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option4  -side top -pady 2 -anchor w -fill x 
	pack $fi.reduction.option5  -side top -pady 2 -anchor w -fill x 
 
    } 
 
    #12 et 13 normal 
 
    #************************ procedure de validation des parametres d'impression ***************** 
 
    proc validerParametresImpression {nomPs laFenetre c} { 
	global format 
	global rotation 
	global reduction 
	global maxX maxY 
	global zoom tpn
 
	affiche "\n" 
#	affiche [format [mc "-Exporting net to PostScript file: %s.ps ..."] $nomPs] 
	affiche [mc "-Exporting net to PostScript file: "] 
        afficheBleu "$nomPs\.ps" 
	affiche " ..." 
	 
	set sauvZoom $zoom 
	set zoom 1 
	redessinerRdP $c 
	 
	set x [expr [tailleX]+50] 
	set y [expr [tailleY]+50] 
	set depassement 0 
 
	if {$reduction > 0} { 
 
	    set largeur [expr $x/$reduction] 
	    if {$rotation ==1} {set pa "nw"} else {set pa "sw"} 
	    #-pageanchor $pa                        -pagex 10 -pagey 10 -x 0 -y 0  \
 
	    $c postscript -file "$nomPs.ps" -height $y -width $x \
		-pagewidth $largeur \
		-x 0 -y 0 -rotate $rotation 
 
	    destroy $laFenetre 
	} else { 
	    #++++ c 'est a dire si reduction automatique +++++++++ 
 
 
	    set hauteur [expr (30-10*$rotation)/$format] 
	    set largeur [expr (20+10*$rotation)/$format] 
	    # calcul de la reduction de l'image : 
	    if { ($x/$largeur)<($y/$hauteur)} {set largeur [expr ($x*$hauteur)/$y]} 
	    set unit "c" 
	    set largeur $largeur$unit 
 
	    $c postscript -file "$nomPs.ps" -height $y -width $x \
		-pagewidth $largeur  \
		-x 0 -y 0 -rotate $rotation 
	    destroy $laFenetre 
 
	} 
	set zoom $sauvZoom 
	redessinerRdP $c 
	affiche [mc "done"] 
    } 
    #------ fin proc valider parametre d'impression 
} 
 
 
 
#***************************************QUITTER*************************************** 
 
proc quitterRdP {w} { 
    global nomRdP tpn
    global modif listeOnglets
    global francais 
 
    set oui 1 
    save_LastOpenFile $nomRdP($tpn)  
    for {set i 0} {$i<[llength $listeOnglets(tpn)]} {incr i} {
	if {$oui == 1} {
#            set tpn  [lindex $listeOnglets(tpn) $i]
            set tpn  [lindex $listeOnglets(indice) $i]
            if {$modif($tpn) ==1} { 
		if {[fautIlSauver]==0} {set oui 0} else {destroy $w.onglet.onglet$tpn}
            } else {
                destroy $w.onglet.onglet$tpn
            }
	}
    }  
    if {$oui == 1} { 
	if {[winfo exists .fenetreCheck]} {
	    destroy .fenetreCheck
	}
	if {[winfo exists .fenetreSimul]} {
	    destroy .fenetreSimul
	}
	if {[winfo exists .control]} {
	    destroy .control
	}
	destroy .romeo
	destroy .
    } 
return 1
} 
 
#*******************************************NOUVEAU****************************************** 
 
proc nouveauRdP {w c} { 
    global tabPlace 
    global tabTransition 
    global tabConstraint
    global nbConstraints
    global nbProcesseur tpn 
    global nomRdP 
    global modif 
    global francais 
    global fin 
    global simulatorOn 
    global listeOnglets
     
    set oui 1 
    if {$simulatorOn==1} { 
	affiche "\n" 
	affiche [mc " -Warning: Not allowed - Quit simulator first"] 
	set oui 0      
    }
# elseif {$modif($tpn) ==1} { 
#	set reponse [tk_messageBox -message [mc "Save net?"] -type yesnocancel -icon question] 
#        switch -exact $reponse { 
#	    cancel { set oui 0 } 
#	    yes { 
#		if {[string compare "$nomRdP($tpn)" "noName.xml"]} { 
#		    enregistrerRdP "$nomRdP($tpn)" 
#		} else { 
#		    enregistrerSousRdP $w} 
#	    } 
#	} 
 #   } 

    if {($oui == 1)&&([existOnglets "noName.xml"]<0)} { 
        nouvelOnglet $w "noName.xml"       
	# nouvelOnglet met à jour tpn
	#        initialisation $c 
	set nbProcesseur($tpn) 0 
	set nomRdP($tpn) "noName.xml" 
 
	# Statut des places : ok, detroy, ou fin 
	set tabPlace($tpn,1,statut) $fin 
        set tabTransition($tpn,1,statut) $fin 

	# Reinit constraints
	set tabConstraint($tpn,0) ""
	set nbConstraints($tpn) 1
 
	set newFTP(transition) 0 
	set newFPT(place) 0 
        redessinerRdP $c 
        queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0 
        set nomRdP($tpn) "noName.xml" 
#	$w.ligneDuBas.indication.nomRdp config -text [format [mc "Net: %s"] "$nomRdP($tpn)"] 
        set modif($tpn) 0 

    } 
} 
 
 
#******************************************* ENREGISTRER ****************************************** 
 
#+++++++++++++++++++++AIGUILLAGE+++++++++++++++++++++++++++ 
# enregistrer alors que nom = noName.xml 
 
proc aiguillageEnregistrer {w} { 
    global modif 
    global nomRdP tpn
    global francais 
    global simulatorOn 
    global synchronized
 
    set oui 1 
    if {$simulatorOn} { 
	set reponse [tk_messageBox -message [mc "The simulator is active. The net will be saved with its current marking. Continue?"] -type yesno -icon question] 
	switch -exact $reponse { 
	    yes {} 
	    no {set oui 0} 
	} 
    } 
     
    if {$oui} { 
	queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0 
	if {[string compare "$nomRdP($tpn)" "noName.xml"]} { 
	    enregistrerTpnXml "$nomRdP($tpn)" 
	} else { 
	    enregistrerSousRdP $w 
	} 
    } 
} 
 
#+++++++++++++++++++++ ENREGISTRER SOUS +++++++++++++++++++++++++++ 
 
proc enregistrerSousRdP {w} { 
 
    global nomRdP tpn
    global modif 
    global cheminFichiers 
    global francais 
    global simulatorOn 
    global synchronized
    global listeOnglets
 
    set oui 1 
    if {$simulatorOn} { 
	set reponse [tk_messageBox -message [mc "The simulator is active. The Petri net will be saved with current marking. Continue ?"] -type yesno -icon question] 
	switch -exact $reponse { 
	    yes {} 
	    no {set oui 0} 
	} 
    } 
    if {$oui} { 
	#   Type names      Extension(s)    Mac File Type(s) 
	# 
	#--------------------------------------------------------- 
	set types { 
	    {{[mc "File"]}     {.xml}      TEXT} 
	} 
	queCreerDetruirePTLPTF $w 0 0 0 0 0 0 0 0 
 
	if [string compare "$nomRdP($tpn)" "noName.xml"] { 
	    set fichier [tk_getSaveFile -filetypes $types  -title [mc "Save net as"] \
			     -initialdir [repertoire $nomRdP($tpn)] -initialfile [nomSeul $nomRdP($tpn)] -defaultextension .xml] 
	} else { 
	    set fichier [tk_getSaveFile -filetypes $types  -title [mc "Save net as"] \
			     -initialdir "$cheminFichiers" -initialfile $nomRdP($tpn) -defaultextension .xml] 
	     
	} 
 
	if [string compare $fichier ""] { 

	    if  {[existOnglets $fichier]>-1} {
#	    affiche "\n -An equivalent tab is already open" 
	    set button [tk_messageBox -icon error  -title "Save as... aborted" -message "An equivalent tab is already open" ] 

	    } else {
		enregistrerTpnXml $fichier 
		set ancien $nomRdP($tpn)
		set nomRdP($tpn) $fichier 
		destroy $w.ligneDuBas.indication.nomRdp 
		label $w.ligneDuBas.indication.nomRdp 
		pack $w.ligneDuBas.indication.nomRdp -side left 
#	    $w.ligneDuBas.indication.nomRdp config -text [format [mc "Net: %s"] $nomRdP($tpn)] 
		set modif($tpn) 0 
		changeNameOngletCourant $w $nomRdP($tpn)
	    }
	} 
    } 
} 
 
#+++++++++++++++++++++ GENERER FICHIER XML +++++++++++++++++++++++++++ 
 
proc enregistrerTpnXml {fichier} { 
    global tabPlace tabTransition tabConstraint 
    global nbProcesseur tpn scheduling 
    global fin ok 
    global modif 
    global infini 
    global tabColor 
    global nbConstraints tpn
    global allowedArc
    global synchronized
 
 
    # toutCommeYFaut 
 
    if {$scheduling==1} {set rien [verifSem 1]} 
 
	if [string compare $fichier ""] { 
	    affiche " \n" 
#	    affiche [format [mc "-Saving net as %s ..."] $fichier] 
	    affiche [mc "-Saving net as "] 
	    afficheBleu $fichier 
            affiche " ..." 
	    set File [open $fichier w] 
	    # ajout guillaume => histoire que les "parseurs" XML savent quoi "parser" 
	    puts $File "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" 
	    puts $File "<TPN name=\"$fichier\">" 
 
	    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} { 
		if {$tabPlace($tpn,$i,statut)==$ok} { 
		    if {$tabPlace($tpn,$i,dmax)==$infini} { 
			set lft "inf" 
		    } else { 
			set lft $tabPlace($tpn,$i,dmax) 
		    } 
		    puts $File "  <place id=\"$i\" label=\"$tabPlace($tpn,$i,label,nom)\" initialMarking=\"$tabPlace($tpn,$i,jeton)\" eft=\"$tabPlace($tpn,$i,dmin)\" lft=\"$lft\"> 
      <graphics color=\"$tabPlace($tpn,$i,color)\"> 
         <position x=\"$tabPlace($tpn,$i,xy,x)\" y=\"$tabPlace($tpn,$i,xy,y)\"\/> 
         <deltaLabel deltax=\"$tabPlace($tpn,$i,label,dx)\" deltay=\"$tabPlace($tpn,$i,label,dy)\"\/> 
      <\/graphics> 
      <scheduling gamma=\"$tabPlace($tpn,$i,processeur)\" omega=\"$tabPlace($tpn,$i,priorite)\"\/> 
  <\/place> \n" 
 
		} 
	    } 
 
	    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} { 
		if {$tabTransition($tpn,$i,statut)==$ok} { 
		    if {$tabTransition($tpn,$i,dmax)==$infini} { 
			set lft "inf" 
		    } else { 
			set lft $tabTransition($tpn,$i,dmax) 
		    } 
		    if {$tabTransition($tpn,$i,minparam)== "" && $tabTransition($tpn,$i,maxparam)== ""} { 
			set params "" 
		    } elseif {$tabTransition($tpn,$i,minparam)!= "" && $tabTransition($tpn,$i,maxparam)!= ""} { 
			set params " eft_param=\"$tabTransition($tpn,$i,minparam)\" lft_param=\"$tabTransition($tpn,$i,maxparam)\"" 
		    } elseif {$tabTransition($tpn,$i,minparam)!= ""} { 
			set params " eft_param=\"$tabTransition($tpn,$i,minparam)\"" 
		    } elseif {$tabTransition($tpn,$i,maxparam)!= ""} { 
			set params " lft_param=\"$tabTransition($tpn,$i,maxparam)\"" 
		    } 
		    puts $File "  <transition id=\"$i\" label=\"$tabTransition($tpn,$i,label,nom)\" \
eft=\"$tabTransition($tpn,$i,dmin)\" lft=\"$lft\"$params  obs=\"$tabTransition($tpn,$i,obs)\"> 
     <graphics color=\"$tabTransition($tpn,$i,color)\"> 
        <position x=\"$tabTransition($tpn,$i,xy,x)\" y=\"$tabTransition($tpn,$i,xy,y)\"\/> 
        <deltaLabel deltax=\"$tabTransition($tpn,$i,label,dx)\" deltay=\"$tabTransition($tpn,$i,label,dy)\"\/> 
     <\/graphics> 
  <\/transition> \n" 
		} 
	    } 
 
	    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} { 
		if {$tabTransition($tpn,$i,statut)==$ok} { 
		    for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} { 
# j'enleve dans le if qui suit : ||(($tabTransition($tpn,$i,PorgType,$j)==4)&&($allowedArc(timedInhibitor)==0))
	               if {!((($tabTransition($tpn,$i,PorgType,$j)==1)&&($allowedArc(reset)==0))||(($tabTransition($tpn,$i,PorgType,$j)==2)&&($allowedArc(read)==0))||(($tabTransition($tpn,$i,PorgType,$j)==3)&&($allowedArc(logicInhibitor)==0)))} {
			   puts $File "  <arc place=\"$tabTransition($tpn,$i,Porg,$j)\" transition=\"$i\" type=\"[typeArc $i $j]\" weight=\"$tabTransition($tpn,$i,PorgWeight,$j)\"> 
    <nail xnail=\"$tabTransition($tpn,$i,PorgNailx,$j)\" ynail=\"$tabTransition($tpn,$i,PorgNaily,$j)\"\/> 
    <graphics  color=\"$tabTransition($tpn,$i,PorgColor,$j)\"> 
     <\/graphics> 
  <\/arc> \n \n" 
		       }
		    } 
		    for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} { 
			puts $File "  <arc place=\"$tabTransition($tpn,$i,Pdes,$j)\" transition=\"$i\" type=\"TransitionPlace\" weight=\"$tabTransition($tpn,$i,PdesWeight,$j)\"> 
     <nail xnail=\"$tabTransition($tpn,$i,PdesNailx,$j)\" ynail=\"$tabTransition($tpn,$i,PdesNaily,$j)\"\/> 
     <graphics  color=\"$tabTransition($tpn,$i,PdesColor,$j)\"> 
     <\/graphics> 
  <\/arc> \n" 
		    } 
		} 
	    } 
 
	    if {[string length $tabConstraint($tpn,0)] > 0} { 
		puts $File "  <misc>" 
		for {set i 0} {$i<$nbConstraints($tpn)}  {incr i} { 
			if {[string length $tabConstraint($tpn,$i)] > 0} { 
				set firstLow [string first "<" $tabConstraint($tpn,$i) 0] 
				set firstHigh [string first ">" $tabConstraint($tpn,$i) 0] 
				set firstEq [string first "=" $tabConstraint($tpn,$i) 0] 
				set left $tabConstraint($tpn,$i) 
				set right $tabConstraint($tpn,$i) 
 
				if {$firstLow > 0} { 
					set left [string replace $left $firstLow end] 
					if {$firstEq > 0} {set op "LowerOrEqual"} else {set op "Lower"} 
					set right [string replace $right 0 [max $firstLow $firstEq]] 
				} elseif {$firstHigh > 0} { 
					set left [string replace $left $firstHigh end] 
					if {$firstEq > 0} {set op "GreaterOrEqual"} else {set op "Greater"} 
					set right [string replace $right 0 [max $firstHigh $firstEq]] 
				} elseif {$firstEq > 0} { 
					set left [string replace $left $firstEq end] 
					set op "Equal" 
					set right [string replace $right 0 $firstEq] 
				} 
				puts $File "     <constraint left=\"$left\" op=\"$op\" right=\"$right\"\/>" 
			} 
		} 
	        puts $File "  <\/misc>\n" 
	   } 
 
# Synchronization-----------
#      puts $File "  <synchronization listSynch=\"$synchronized\"> \n <\/synchronization> \n" 
	     
# Preferences------------- 
     puts $File "  <preferences> " 
	  set colorPlace ""   
	  set colorTransition ""   
	  set colorArc ""   
      for {set i 0} {$i <= 5} {incr i} { 
	    set colorPlace "$colorPlace c$i=\"$tabColor(Place,$i)\" " 
	    set colorTransition "$colorTransition c$i=\"$tabColor(Transition,$i)\" " 
	    set colorArc "$colorArc c$i=\"$tabColor(Arc,$i)\" " 
      }  
 
     puts $File "      <colorPlace $colorPlace\/> \n " 
     puts $File "      <colorTransition $colorTransition\/> \n " 
     puts $File "      <colorArc $colorArc\/> \n " 
     puts $File "  <\/preferences> \n <\/TPN> \n" 
     close $File 
	 affiche [mc "done"] 
	 set modif($tpn) 0 
         update idletasks
	} 
} 
 
proc typeArc {indiceT indiceIP} { 
    global tabTransition tpn
 
	return [nomTypeArc $tabTransition($tpn,$indiceT,PorgType,$indiceIP)]     
}   
 
proc nomTypeArc {numType} { 
    if {$numType==0} {  
	  return "PlaceTransition" 
    } elseif {$numType==1} {  
	  return "flush" 
    } elseif {$numType==2} {  
	  return "read" 
    } elseif {$numType==3} {  
	  return "logicalInhibitor" 
    } else { return "timedInhibitor"} 
}     
#++++++++++++++++++++++++++++++++++++++++++++++ 
 
 
#++++++++++++Verif nbPlace amont /proc(P)>0 est <2 ++++++ 
 
proc verifSem {avecAffichage} { 
    global tabPlace 
    global tabTransition 
    global nbProcesseur tpn 
    global fin 
    global ok 
    global francais 
 
    set erreurSemantique "" 
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin} {incr i} { 
        set amontOrdo 0 
        if {$tabTransition($tpn,$i,statut)==$ok} { 
            for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0} {incr j} { 
                if {($tabPlace($tpn,$tabTransition($tpn,$i,Porg,$j),processeur)>0)&&($tabTransition($tpn,$i,PorgType,$j)==0)} {incr amontOrdo} 
            } 
            if {$amontOrdo>1} { 
                if {$francais} { 
                    set erreurSemantique "$erreurSemantique \n               * Transition \" $tabTransition($tpn,$i,label,nom) \"  :  $amontOrdo arcs Pi->$tabTransition($tpn,$i,label,nom) avec proc(Pi)>0" 
                } else {     
                    set erreurSemantique "$erreurSemantique \n               * Transition \" $tabTransition($tpn,$i,label,nom) \"  :  $amontOrdo arcs Pi->$tabTransition($tpn,$i,label,nom) such that proc(Pi)>0 " 
                } 
            } 
        } 
    } 
    if {$erreurSemantique !=""} { 
	    affiche "\n > Semantic Error : $erreurSemantique" 
	    if {$avecAffichage==1} { 
	    set button [tk_messageBox -icon error -message [format [mc "Semantic error:  \n \n %s "] $erreurSemantique]] 
	} 
	return 0 
    } else { return 1 } 
} 
 
 
 
#+++++++++++++++++++++AFFICHAGE DANS LA FENETRE DE RESULTAT DE ROMEO +++++++++++++++++++++ 
 
proc affiche {texte} { 
    .romeo.global.out.texte insert end $texte 
    .romeo.global.out.texte yview moveto 1 
     update idletasks
 
}  
 
proc afficheBleu {texte} { 
    .romeo.global.out.texte tag configure bleu -foreground blue 
    .romeo.global.out.texte insert end $texte bleu 
    .romeo.global.out.texte yview moveto 1 
     update idletasks
}  
  
proc afficheMarron {texte} { 
    .romeo.global.out.texte tag configure marron -foreground brown 
    .romeo.global.out.texte insert end $texte marron 
    .romeo.global.out.texte yview moveto 1 
     update idletasks
}  

proc afficheRouge {texte} { 
    .romeo.global.out.texte tag configure rouge -foreground red 
    .romeo.global.out.texte insert end $texte rouge 
    .romeo.global.out.texte yview moveto 1 
     update idletasks
}  
 
#+++++++++++++++++++++AFFICHAGE GPN.LOG +++++++++++++++++++++ 
 
 
proc afficheGpnLog {lepid fichier} { 
    global plateforme 
 
    if {![string compare $plateforme "Darwin"]} { 
 
	if { [catch {open $fichier r} ep] } { 
	    affiche [format [mc "Unable to open %s"] $fichier] 
	} else { 
	    set File [open $fichier r] 
	    fileevent $File readable [afficheChannel $lepid 0 $File] 
	} 
    } else { 
	afficheBackGround $lepid "" 
    } 
} 
 
proc afficheBackGround {lepid lachaine} { 
    global plateforme 
 
    affiche "\n        $lepid >      " 
    affiche [format [mc "-Process %d will continue in background"] $lepid] 
 
    if {$lachaine != ""} { 
        affiche "\n        $lepid >      " 
        affiche [mc "-The file "]  
        afficheBleu $lachaine 
        affiche [mc " will be generated"] 
    } 
    if {[string compare $plateforme "windows"]} { 
	affiche "\n        $lepid >      "  
	affiche [mc "-Use ps (or top) command to display information about processes."] 
	#     affiche "\n        $lepid >      " 
	#     affiche [format [mc "-Use kill -9 %d to terminate the process."] $lepid] 
    } else { 
	affiche "\n        $lepid >      " 
	affiche [mc "-Use alt/ctrl/sup to manage the process."] 
    } 
} 
 
proc attendreAffiche  {lepid temps File} { 
 
    incr temps 
    if {($temps/10.0)==($temps/10)} { 
	  affiche "\n        $lepid >      " 
	  affiche [format [mc "...running time : %d  s ..."] [expr $temps*2]] 
    } 
    if {$temps<100} { 
	  after cancel afficheChannel $lepid $temps $File 
	  if {[catch [after 2000 afficheChannel $lepid $temps $File]]} {} 
    } else { 
	   affiche "\n        $lepid >      " 
	   affiche [mc "Running time display aborted"] 
	   afficheBackGround $lepid "" 
    } 
} 
 
proc afficheChannel {lepid temps File} { 
    set endOfFil 0 
    set nlig [tell $File]  
    set ligne [gets $File]  
    seek $File $nlig start 
    while {([eof $File] <1) && ([fblocked $File] <1)} { 
	set ligne [gets $File] 
	if {![string compare [nextExpression $ligne " "] "Total"]} { 
	    set endOfFil 1 
	} 
	if {[string compare $ligne ""]} { 
	    affiche "\n        $lepid >      $ligne " 
            update idletasks
	} 
    }  
    set nlig [tell $File]     
    if {$endOfFil==0} { 
	fileevent $File readable [attendreAffiche $lepid $temps $File] 
    } else { 
	close $File 
    } 
} 
 
 
#+++++++++++++++++++++FIN AFFICHAGE GPN.LOG +++++++++++++++++++++ 
 
 
proc tailleX {} { 
    global tabPlace tpn
    global tabTransition 
    global fin 
    global ok 
    global maxX 
 
    set lplX 0 
 
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} { 
        if {$tabPlace($tpn,$i,statut)==$ok} { 
	    if { $tabPlace($tpn,$i,xy,x) > $lplX } { 
		set lplX  $tabPlace($tpn,$i,xy,x) 
	    } 
	    if { ($tabPlace($tpn,$i,xy,x)+$tabPlace($tpn,$i,label,dx)) > $lplX } { 
		set lplX  [expr $tabPlace($tpn,$i,xy,x)+$tabPlace($tpn,$i,label,dx)] 
	    } 
        } 
    } 
 
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} { 
	if {$tabTransition($tpn,$i,statut)==$ok} { 
	    if { $tabTransition($tpn,$i,xy,x) > $lplX } { 
		set lplX $tabTransition($tpn,$i,xy,x) 
	    } 
	    if { ($tabTransition($tpn,$i,xy,x)+$tabTransition($tpn,$i,label,dx)) > $lplX } { 
		set lplX [expr $tabTransition($tpn,$i,xy,x)+$tabTransition($tpn,$i,label,dx)] 
	    } 
	    for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} { 
		if {$tabTransition($tpn,$i,PorgNailx,$j)>$lplX } { 
		    set lplX $tabTransition($tpn,$i,PorgNailx,$j) 
		} 
	    } 
	    for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} { 
		if {$tabTransition($tpn,$i,PdesNailx,$j)>$lplX } { 
		    set lplX $tabTransition($tpn,$i,PdesNailx,$j) 
		} 
	    } 
	} 
    } 
 
    # set lplX [expr 50*($lplX+20)/$maxX] 
    return $lplX 
 
} 
 
 
proc tailleY {} { 
    global tabPlace tpn
    global tabTransition 
    global fin 
    global ok 
    global maxY 
 
    set lplY 0 
 
    for {set i 1} {$tabPlace($tpn,$i,statut)!=$fin} {incr i} { 
        if {$tabPlace($tpn,$i,statut)==$ok} { 
	    if {$tabPlace($tpn,$i,xy,y) > $lplY} { 
		set lplY  $tabPlace($tpn,$i,xy,y) 
	    } 
	    if { ($tabPlace($tpn,$i,xy,y)+$tabPlace($tpn,$i,label,dy)) > $lplY } { 
		set lplY  [expr $tabPlace($tpn,$i,xy,y)+$tabPlace($tpn,$i,label,dy)] 
	    } 
        } 
    } 
 
    for {set i 1} {$tabTransition($tpn,$i,statut)!=$fin}  {incr i} { 
        if {$tabTransition($tpn,$i,statut)==$ok} { 
            if {$tabTransition($tpn,$i,xy,y) > $lplY} { 
		set lplY $tabTransition($tpn,$i,xy,y) 
            } 
 	    if { ($tabTransition($tpn,$i,xy,y)+$tabTransition($tpn,$i,label,dy)) > $lplY } { 
		set lplY [expr $tabTransition($tpn,$i,xy,y)+$tabTransition($tpn,$i,label,dy)] 
            } 
	    for {set j 1} {$tabTransition($tpn,$i,Porg,$j) >0}   {incr j} { 
		if {$tabTransition($tpn,$i,PorgNaily,$j)>$lplY } { 
		    set lplY $tabTransition($tpn,$i,PorgNaily,$j) 
		} 
	    } 
	    for {set j 1} {$tabTransition($tpn,$i,Pdes,$j) >0}   {incr j} { 
		if {$tabTransition($tpn,$i,PdesNaily,$j)>$lplY } { 
		    set lplY $tabTransition($tpn,$i,PdesNaily,$j) 
		} 
	    } 
	} 
    } 
    #set lplY [expr 33*($lplY+20)/$maxY] 
    return $lplY 
} 
 
 
 
proc sansEspace {phrase} { 
    set x 0 
    while {[string index $phrase $x] == " "} {incr x} 
    set phrase [string range $phrase $x [string length $phrase] ] 
 
    set espace [string first " " $phrase] 
    while {$espace > 0} { 
	set concatGauche [string range $phrase 0 [expr $espace -1]] 
	set concatDroite [string range $phrase [expr $espace + 1] [string length $phrase] ] 
 
	set phrase "$concatGauche$concatDroite" 
	set espace [string first " " $phrase] 
    } 
    return $phrase 
} 
 

proc retirerListeCar {phrase listeCar} { 
  for {set i 0} {$i<[llength $listeCar]} {incr i} {
     set car  [lindex $listeCar $i]
     set x 0 
     while {[string index $phrase $x] == $car} {incr x} 
     set phrase [string range $phrase $x [string length $phrase] ] 
 
     set indice [string first $car $phrase] 
     while {$indice > 0} { 
	set concatGauche [string range $phrase 0 [expr $indice -1]] 
	set concatDroite [string range $phrase [expr $indice + 1] [string length $phrase] ] 
 
	set phrase "$concatGauche$concatDroite" 
 	set indice [string first $car $phrase] 
     } 
  }
  return $phrase 
} 
 
 
proc slach {phrase} { 
    set antislach "\\" 
    set espace [string first "/" $phrase] 
    while {$espace > 0} { 
	set concatGauche [string range $phrase 0 [expr $espace -1]] 
	set concatDroite [string range $phrase [expr $espace + 1] [string length $phrase] ] 
 
	set phrase "$concatGauche$antislach$concatDroite" 
	set espace [string first "/" $phrase] 
    } 
    return $phrase 
} 
 
proc parcourir {repertoire} { 
 
    set repertoireChoisi [tk_chooseDirectory -initialdir $repertoire \
			      -title [mc "Choose a directory"]] 
    if [string compare $repertoireChoisi ""] { 
        return $repertoireChoisi 
    } else { 
        return $repertoire 
    } 
} 
 
proc repertoire {nomFichier} { 
 
    set last [string last "/" $nomFichier] 
 
    if {$last>=0} {set resultat [string range $nomFichier 0 [expr $last -1]] 
    } else {set resultat "./"} 
    return $resultat 
} 
 
proc nomSeul {nomFichier} { 
 
    set last [string last "/" $nomFichier] 
 
    if {$last>=0} {set resultat [string range $nomFichier [expr $last +1] [string length $nomFichier] ] 
    } else {set resultat $nomFichier} 
    return $resultat 
} 

proc sansXml {nomFichier} { 

    set last [string first ".xml" "$nomFichier"] 

    if {$last>=0} {
     return [string range "$nomFichier" 0 [expr $last -1]] 
    } else {
      return $nomFichier
    }

}