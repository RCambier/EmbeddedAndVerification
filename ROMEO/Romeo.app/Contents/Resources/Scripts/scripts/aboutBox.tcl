package require Img
wm title  . "About Romeo"

image create photo logoRomeo -file "img/romeo.png"

# frame supérieur
label .logo -image logoRomeo
pack .logo -side top

label .title -text "Romeo" 
font create title_font -size 20 -weight bold
.title configure -font title_font
pack .title -side top

label .version -text "v2.9.1"
font create version_font -size 10
.version configure -font version_font
pack .version -side top

font create licence_font -size 10 -slant italic
label .licence -text "Released under the CeCILL Licence" -font licence_font
pack .licence -side top

label .contact_title -text "Contact:" -font [font create -size 12 -weight bold]
label .contact_mail -text "romeo@irccyn.ec-nantes.fr" -font [font create -size 12]
pack .contact_title -side top
pack .contact_mail -side top
