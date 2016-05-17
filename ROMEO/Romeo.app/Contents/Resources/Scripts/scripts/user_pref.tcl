#
# User Management system
#
# Unix (Linux+MacOsX) -> save pref in ~/.romeo
# Windows -> save pref elsewhere, not decided presently

#
# Load user preferences in sent_array
# The user preferences file must exist
     
proc load_preferences {} {
    global cheminFichiers
    global cheminEditeur 
    global cheminExe
    global dos 
    global editAuto 
    global francais 
    global scheduling parameters allowedArc outFormat typePN
    global maxX maxY 
    global gpnU gpnK mercutioU mercutioK
     
    global tcl_platform
    global env
    global tabColor defaultTabColor

    set target $tcl_platform(platform)
    set prefFile ""
    
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set prefFile [file join $env(HOME) ".romeo/preferences"]
    } else {
        set prefFile [file join $env(HOME) "Preferences/.romeo/preferences"] 
        # set to the directory where is installed the application
        # handle windows platform
    }
    
    #open prefFile
    set file [open $prefFile r]
    # read the file
    set full_text [read $file]
    close $file
    # split lines
	set lines [split $full_text "\n"]
	#match each line
	foreach line $lines {
        regexp "(.*):(.*)" $line match title value
        if {$value=="outFormat(ta)"} {
            set outFormat(ta) $value
        } elseif {$value=="outFormat(scg)"} {
            set outFormat(scg) $value
        } elseif { $value=="allowedArc(reset)"} {
            set allowedArc(reset) $value
        } elseif { $value=="allowedArc(read)"} {
            set allowedArc(read) $value
        } elseif { $value=="allowedArc(logicInhibitor)"} {
            set allowedArc(logicInhibitor) $value
        } elseif { $value=="allowedArc(timedInhibitor)"} {
            set allowedArc(timedInhibitor) $value
        } else {
            set $title $value
        }
        
	}
}

#
# Save an array to the user preferences file (overwritte)


proc save_preferences {} {
    global cheminFichiers
    global cheminEditeur 
    global cheminExe
    global dos 
    global editAuto 
    global francais 
    global scheduling parameters allowedArc outFormat typePN
    global maxX maxY 
    global gpnU gpnK mercutioU mercutioK
    global tabColor defaultTabColor
    global tcl_platform
    global env
    
    set target $tcl_platform(platform)
    set prefFile ""
    
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set prefFile [file join $env(HOME) ".romeo/preferences"]
    } else {
        set prefFile [file join $env(HOME) "Preferences/.romeo/preferences"] 
         # set to the directory where is installed the application
        # handle windows platform
    }
    
    #open prefFile
    set file [open $prefFile w]
    puts $file "outFormat(scg):$outFormat(scg)" 
    puts $file "outFormat(ta):$outFormat(ta)" 
    puts $file "scheduling:$scheduling" 
    puts $file "typePN:$typePN" 
    puts $file "parameters:$parameters" 
    puts $file "allowedArc(reset):$allowedArc(reset)"
    puts $file "allowedArc(read):$allowedArc(read)"
    puts $file "allowedArc(logicInhibitor):$allowedArc(logicInhibitor)"
    puts $file "allowedArc(timedInhibitor):$allowedArc(timedInhibitor)"
    puts $file "dos:$dos"
    puts $file "editAuto:$editAuto"
    puts $file "francais:$francais"
    puts $file "cheminExe:$cheminExe" 
    puts $file "cheminFichiers:$cheminFichiers" 
    puts $file "cheminEditeur:$cheminEditeur" 
    puts $file "maxX:$maxX"
    puts $file "maxY:$maxY"
    puts $file "gpnU:$gpnU"
    puts $file "gpnK:$gpnK"
    puts $file "mercutioU:$mercutioU"
    puts $file "mercutioK:$mercutioK"
    for {set i 0} {$i <= 5}   {incr i} {
      puts $file "tabColor(Arc,$i):$tabColor(Arc,$i)" 
      puts $file "tabColor(Place,$i):$tabColor(Place,$i)" 
      puts $file "tabColor(Transition,$i):$tabColor(Transition,$i)" 
      puts $file "defaultTabColor(Arc,$i):$defaultTabColor(Arc,$i)" 
      puts $file "defaultTabColor(Place,$i):$defaultTabColor(Place,$i)" 
      puts $file "defaultTabColor(Transition,$i):$defaultTabColor(Transition,$i)" 
    }

    close $file
}

proc preferences_filename {} {
    global tcl_platform
    global env
    set target $tcl_platform(platform)
    set prefFile ""
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set prefFile [file join $env(HOME) ".romeo/preferences"]
    } else {
        set prefFile [file join $env(HOME) "Preferences/.romeo/preferences"] 
         # set to the directory where is installed the application
        # handle windows platform
    }
    return $prefFile
}

proc preferences_dir {} {
    global tcl_platform
    global env
    set target $tcl_platform(platform)
    set prefDir ""
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set prefDir [file join $env(HOME) ".romeo"]
    } else {
        set prefDir [file join $env(HOME) "Preferences/.romeo"] 
        # set to the directory where is installed the application
        # handle windows platform
    }
    return $prefDir
}

proc temp_dir {} {
    global tcl_platform
    global env
    set target $tcl_platform(platform)
    set tempDir ""
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set tempDir [file join $env(HOME) ".romeo/temp"]
    } else {
        set tempDir [file join $env(HOME) "Preferences/.romeo/temp"] 
        # set to the directory where is installed the application
        # handle windows platform
    }
    return $tempDir
}


proc save_default_preferences {} {    
    global tcl_platform
    global env
    
    set target $tcl_platform(platform)
    set prefFile ""
    
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set prefFile [file join $env(HOME) ".romeo/preferences"]
    } else {
        set prefFile [file join $env(HOME) "Preferences/.romeo/preferences"] 
         # set to the directory where is installed the application
        # handle windows platform
    }
    
    #open prefFile
    set file [open $prefFile w]
    puts $file "outFormat(scg):1" 
    puts $file "outFormat(ta):1" 
    puts $file "scheduling:0" 
    puts $file "typePN:1" 
    puts $file "allowedArc(reset):1"
    puts $file "allowedArc(read):1"
    puts $file "allowedArc(logicInhibitor):1"
    puts $file "allowedArc(timedInhibitor):0"
    puts $file "dos:0"
    puts $file "editAuto:0"
    puts $file "francais:0"
    puts $file "cheminExe:." 
    puts $file "cheminFichiers:." 
    puts $file "cheminEditeur:." 
    puts $file "maxX:1900"
    puts $file "maxY:900"
    puts $file "gpnU:1"
    puts $file "gpnK:1"
    puts $file "mercutioU:0"
    puts $file "mercutioK:0"
    puts $file "tabColor(Arc,0):black"
    puts $file "tabColor(Arc,1):gray"
    puts $file "tabColor(Arc,2):blue"
    puts $file "tabColor(Arc,3):#beb760"
    puts $file "tabColor(Arc,4):#be5c7e"
    puts $file "tabColor(Arc,5):#46be90"
    puts $file "tabColor(Transition,0):yellow"
    puts $file "tabColor(Transition,1):gray"
    puts $file "tabColor(Transition,2):cyan"
    puts $file "tabColor(Transition,3):green"
    puts $file "tabColor(Transition,4):SkyBlue2"
    puts $file "tabColor(Transition,5):brown"
    puts $file "tabColor(Place,0):SkyBlue2"
    puts $file "tabColor(Place,1):gray"
    puts $file "tabColor(Place,2):cyan"
    puts $file "tabColor(Place,3):green"
    puts $file "tabColor(Place,4):yellow"
    puts $file "tabColor(Place,5):brown"
    puts $file "defaultTabColor(Arc,0):black"
    puts $file "defaultTabColor(Arc,1):gray"
    puts $file "defaultTabColor(Arc,2):blue"
    puts $file "defaultTabColor(Arc,3):#beb760"
    puts $file "defaultTabColor(Arc,4):#be5c7e"
    puts $file "defaultTabColor(Arc,5):#46be90"
    puts $file "defaultTabColor(Transition,0):yellow"
    puts $file "defaultTabColor(Transition,1):gray"
    puts $file "defaultTabColor(Transition,2):cyan"
    puts $file "defaultTabColor(Transition,3):green"
    puts $file "defaultTabColor(Transition,4):SkyBlue2"
    puts $file "defaultTabColor(Transition,5):brown"
    puts $file "defaultTabColor(Place,0):SkyBlue2"
    puts $file "defaultTabColor(Place,1):gray"
    puts $file "defaultTabColor(Place,2):cyan"
    puts $file "defaultTabColor(Place,3):green"
    puts $file "defaultTabColor(Place,4):yellow"
    puts $file "defaultTabColor(Place,5):brown"

    close $file
}


proc load_LastOpenFile {w c} {
     
    global tcl_platform
    global env

    set target $tcl_platform(platform)
    set lastOpenFile ""
    
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set lastOpenFile [file join $env(HOME) ".romeo/lastOpen"]
    } else {
#preferences"] 
        set lastOpenFile [file join $env(HOME) "Preferences/.romeo/lastOpen"]
        # set to the directory where is installed the application
        # handle windows platform
    }
    
   if {[file exists $lastOpenFile]} {

      #open prefFile
      set file [open $lastOpenFile r]
      # read the file
      gets $file fileName 
      close $file
      if {[file exists $fileName]} {
         ouvrirPointXML $w $c 0 $fileName
      } else { 
         nouveauRdP $w $c
      }
   } else { 
         nouveauRdP $w $c
   }
      
}

proc save_LastOpenFile {fileName} {
     
    global tcl_platform
    global env

    set target $tcl_platform(platform)
    set lastOpenFile ""
    
    # first check the system
    if {[string compare $target "unix"] == 0} {
        # set to ~/.romeo
        set lastOpenFile [file join $env(HOME) ".romeo/lastOpen"]
    } else {
#preferences"] 
        set lastOpenFile [file join $env(HOME) "Preferences/.romeo/lastOpen"]
        # set to the directory where is installed the application
        # handle windows platform
    }
    
      #open prefFile
      set file [open $lastOpenFile w]
      # read the file
      puts $file $fileName 
      close $file
}
