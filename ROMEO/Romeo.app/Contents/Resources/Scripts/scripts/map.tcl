proc chemin {} {
     global cheminFichiers
     global cheminEditeur 
     global cheminExe
     global dos 
     global editAuto 
     global francais 
     global scheduling parameters allowedArc outFormat typePN
     global maxX maxY 
     global gpnU gpnK mercutioU mercutioK 
 
     set outFormat(scg) 1 
     set outFormat(ta) 1 
     set scheduling 0 
     set parameters 0
     set typePN 1
     set allowedArc(timedInhibitor) 0 
     set allowedArc(reset) 1 
     set dos 0
     set editAuto 0
     set francais 1
     set cheminExe "./" 
     set cheminFichiers "../examples/" 
     set cheminEditeur "" 
     set maxX 1907.0
     set maxY 960.5
     set gpnU 1
     set gpnK 1
     set mercutioU 0
     set mercutioK 0
    } 
