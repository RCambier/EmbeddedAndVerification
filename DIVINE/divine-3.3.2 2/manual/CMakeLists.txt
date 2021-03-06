# TODO

set( SOURCES title.mdwn overview.mdwn building.mdwn commands.mdwn
             using.mdwn llvm.mdwn dve.mdwn timed.mdwn cesmi.mdwn
             dess.mdwn ../HACKING )

if( PDFLATEX AND BIBTEX )
  add_custom_command(
    OUTPUT manual.pdf
    DEPENDS ${SOURCES}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND pandoc --smart -N --toc -o ${CMAKE_CURRENT_BINARY_DIR}/manual.pdf ${SOURCES}
  )
  set( PDFMAN "manual.pdf" )
endif()

if( GUI AND QCOLLECTIONGENERATOR_EXECUTABLE )
    add_custom_command(OUTPUT divine.qhc manual.qch
                       COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/divine.qhcp .
                       COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/manual.qhp .
                       COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/about.txt .
                       COMMAND ${QT_QCOLLECTIONGENERATOR_EXECUTABLE} divine.qhcp
                       DEPENDS manual.html ${CMAKE_CURRENT_SOURCE_DIR}/divine.qhcp
                               ${CMAKE_CURRENT_SOURCE_DIR}/manual.qhp )
  set( QTHELP "divine.qhc;manual.qch" )
endif()

add_custom_command(
  OUTPUT manual.html
  DEPENDS ${SOURCES}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMAND pandoc --smart -s -N --toc -o ${CMAKE_CURRENT_BINARY_DIR}/manual.html ${SOURCES}
)

add_custom_command(
  OUTPUT divine.1
  DEPENDS commands.mdwn
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMAND pandoc --smart -s --to man -o ${CMAKE_CURRENT_BINARY_DIR}/divine.1 commands.mdwn
)

add_custom_target( manual ALL DEPENDS ${PDFMAN} ${QTHELP} manual.html divine.1 )

include( GNUInstallDirs )

if( WIN32 )
  install( FILES manual.html DESTINATION ./ COMPONENT sys )
else()
  install( FILES "${CMAKE_CURRENT_BINARY_DIR}/divine.1"
           DESTINATION ${CMAKE_INSTALL_MANDIR}/man1 COMPONENT doc )
  install( FILES "${CMAKE_CURRENT_BINARY_DIR}/manual.html"
           DESTINATION ${CMAKE_INSTALL_DOCDIR} COMPONENT doc )
  if ( PDFMAN )
      install( FILES "${CMAKE_CURRENT_BINARY_DIR}/manual.pdf"
               DESTINATION ${CMAKE_INSTALL_DOCDIR} COMPONENT doc )
  endif()
endif()
